class Movie::GracenoteApiManager

  # order by preferences
  # http://www.any-video-converter.com/video-settings-for-iphone.php
  TRAILER_FORMATS = [
      471, # 640X480_1M
      472, # 640X360_1M
      461, # 480X270_700K
      455, # 480X360_700K
      452, # 320X240_300K
      457, # 320X180_300K
      456, # 176X132_112K
      460, # 176X100_112K
  ]

  QUERY_TRAILER_FORMAT = TRAILER_FORMATS.join(',')

  def initialize(client_ip)
    @client_ip = client_ip
  end

  def list_playing_movies(zipcode:, latitude:, longitude:)
    result = []
    if zipcode.blank? && (longitude.blank? || latitude.blank?)
      Rails.logger.error 'either zipcode or coordinates must be provided for listing movies currently playing in local theatres'
      return result
    end

    # cache forever, actually, everyday, there will be a new URL!
    content_json = get_response(url_prefix: 'movies/showings',
                                api_type: 'PLAYING_MOVIES',
                                query_string: "#{geo_with_current_date_days_query_string(
                                    zipcode, latitude, longitude)}&imageSize=Lg&imageText=false")

    return result if content_json.blank?
    result = filter_film_entries(content_json)

    unless result.blank?
      GracenotePrefetcher.perform_async(
          {
              action: 'all_movie_related_info',
              client_ip: @client_ip,
              location: {zipcode: zipcode, latitude: latitude, longitude: longitude},
              movie_ids: result.map { |mv| {root_id: mv['rootId'], tms_id: mv['tmsId']} },
          })
    end

    result
  end

  def movie_detail(root_id:, tms_id:)
    return {} if tms_id.blank?
    # cache a month, actually the changing data is the ratings but it will be replaced by a dedicated API
    get_response(url_prefix: "programs/#{tms_id}",
                 api_type: 'MOVIE_DETAIL',
                 query_string: 'imageSize=Lg&imageText=false')
  end

  def celebrity_detail(person_id)
    # cache a month
    r = get_response(url_prefix: "celebs/#{person_id}",
                     api_type: 'CELEB_DETAIL',
                     query_string: 'imageSize=Lg&imageText=false')
    update_celeb_mappings(r)
    r
  end

  def find_theatres(zipcode:, latitude:, longitude:)
    # cache a month,
    r = get_response(url_prefix: "theatres",
                     api_type: 'THEATRES_BY_GEO',
                     query_string: "#{geo_query_string(zipcode, latitude, longitude)}&numTheatres=200")
    store_individual_theatres(r)
    r
  end

  def movie_showtimes(tms_id:, zipcode:, latitude:, longitude:)
    # cache 4 hours
    ms = get_response(url_prefix: "movies/#{tms_id}/showings",
                      api_type: 'SHOWTIMES_BY_MOVIE',
                      query_string: "#{geo_with_current_date_days_query_string(zipcode, latitude, longitude)}&imageSize=Lg&imageText=false")
    return nil if ms.blank?
    ms[0]
  end

  def theatre_detail(theatre_id)
    # NOTE: when changing URL or return json, remember to update method update_theater_detail_cache

    # cache a month
    get_response(url_prefix: "theatres/#{theatre_id}",
                 api_type: 'THEATRE_DETAIL',
                 query_string: nil)
  end

  def trailers(root_id)
    # cache a month
    get_response(url_prefix: "screenplayTrailers",
                 api_type: 'TRAILERS_BY_MOVIE',
                 query_string: "rootids=#{root_id}&bitrateids=#{QUERY_TRAILER_FORMAT}&trailersonly=1") do |response_json|
      if response_json.blank? || response_json['response'].blank?
        nil
      else
        response_json['response']['trailers']
      end
    end
  end

  def search_movies(search_term, page, per)
    default_res = {
        # use string hash key for compatible with api result
        'hitCount' => 0,
        'hits' => []
    }
    return default_res if search_term.blank?

    page = 0 if page.blank?
    per = 25 if per.blank?

    get_response(url_prefix: "programs/search",
                 api_type: 'SEARCH_MOVIE',
                 query_string:
                     "q=#{CGI::escape(search_term)}&" +
                         "queryFields=#{CGI::escape('title')}&" +
                         "entityType=#{CGI::escape('movie')}&" +
                         'includeAdult=false&' +
                         'imageSize=Md&' +
                         'imageText=false&' +
                         "offset=#{page}&" +
                         "limit=#{per}&" +
                         'titleLang=en&' +
                         'descriptionLang=en') || default_res
  end

  private

  def filter_film_entries(playing_movies_json)
    playing_movies_json.select { |mv|
      mv['subType'] != 'Short Film' &&
      !mv['title'].blank? &&
          !mv['genres'].blank? &&
          !mv['preferredImage'].blank? && !mv['preferredImage']['uri'].blank? &&
          !mv['longDescription'].blank? &&
          !mv['directors'].blank? &&
          !mv['showtimes'].blank?
    }
  end

  def geo_with_current_date_days_query_string(zipcode, latitude, longitude)
    local_date = TimeHelper.current_local_date(zipcode: zipcode, latitude: latitude, longitude: longitude)

    start_date = local_date.strftime("%Y-%m-%d")
    query_string = "startDate=#{start_date}&numDays=#{ENV['MOVIE_SEARCH_NUM_SCHEDULE_DAY']}"
    "#{query_string}&#{geo_query_string(zipcode, latitude, longitude)}"
  end

  def geo_query_string(zipcode, latitude, longitude)
    if longitude.blank? && latitude.blank?
      query_string = "zip=#{zipcode}&radius=#{ENV['MOVIE_SEARCH_RADIUS_KM']}&units=#{ENV['MOVIE_SEARCH_DISTANCE_UNIT']}"
    else
      query_string = "lat=#{latitude}&lng=#{longitude}&radius=#{ENV['MOVIE_SEARCH_RADIUS_KM']}&units=#{ENV['MOVIE_SEARCH_DISTANCE_UNIT']}"
    end

    query_string
  end

  def get_response(url_prefix:, api_type:, query_string:)
    uri = build_uri(url_prefix: url_prefix, query_string: query_string)

    response_json = read_from_cache(uri)
    return response_json unless response_json.blank?

    response_json = call_api(uri)

    if block_given?
      response_json = yield response_json
    end

    unless response_json.blank?
      update_cache(api_type, uri, response_json)
    end

    response_json
  end

  def build_uri(url_prefix:, query_string:)
    if query_string.blank?
      "#{ENV['MOVIE_GRACENOTE_API_BASE_URL']}/#{build_authorization_parameters(url_prefix)}"
    else
      "#{ENV['MOVIE_GRACENOTE_API_BASE_URL']}/#{build_authorization_parameters(url_prefix)}&#{query_string}"
    end
  end

  def call_api(uri)
    response_json = nil
    RestClient.get(uri) { |res|
      case res.code
        when 200
          if res.body.blank?
            Rails.logger.error "calling Gracenote API #{uri} returns empty response"
          else
            response_json = JSON.parse(res.body)
          end
        else
          Rails.logger.error "Error while calling Gracenote API #{uri}. Status code: #{res.code}. Message #{res.body}"
      end
    }
    response_json
  end

  def read_from_cache(uri)
    Movie::MovieCacheManager::read_from_cache(uri)
  end

  def update_cache(api_type, uri, response_json)
    Movie::MovieCacheManager::update_cache(api_type, uri, response_json, @client_ip)
  end

  def build_authorization_parameters(api)
    "#{api}?api_key=#{ENV['MOVIE_GRACENOTE_API_KEY']}"
  end

  def store_individual_theatres(theatres_by_location)
    return if theatres_by_location.blank?
    theatres_by_location.each do |th|
      clone = th.clone
      clone['location'] = clone['location'].except(:distance)
      update_theater_detail_cache(clone['theatreId'], clone)
    end
  end

  def update_theater_detail_cache(theatre_id, response_json)
    update_cache('THEATRE_DETAIL', build_uri(url_prefix: "theatres/#{theatre_id}", query_string: nil), response_json)
  end

  def update_celeb_mappings(c)
    return if c.blank?

    m = MovieCelebrityMapping.find_by(person_id: c['personId'], source: 'GRACENOTE')

    if m.blank?
      MovieCelebrityMapping.create(
          {
              person_id: c['personId'],
              source: 'GRACENOTE',
              name: "#{c['name']['first']} #{c['name']['last']}",
              name_lower: "#{c['name']['first']} #{c['name']['last']}".downcase,
              image_uri: c['preferredImage']['uri'],
          })
    else
      m.update_attributes(
          {
              name: "#{c['name']['first']} #{c['name']['last']}",
              name_lower: "#{c['name']['first']} #{c['name']['last']}".downcase,
              image_uri: c['preferredImage']['uri'],
          })
    end
  end
end
class Movie::GracenoteMovieService
  NUMBER_OF_HIGHLIGHTED_MOVIES = 4

  def initialize(client_ip)
    @client_ip = client_ip
    @gracenote_manager = Movie::GracenoteApiManager.new(@client_ip)
  end

  def list_genres(zipcode:, latitude:, longitude:)
    movies = gracenote_movies(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_tz = TimeHelper.local_timezone(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_date = TimeHelper.get_current_local_date(local_tz)

    now_showing_movies = movies.select { |mv| is_now_showing(mv, local_tz, local_date) }
    now_showing_movies.map { |mv| mv['genres'] }.flatten.uniq.reject { |g| g.blank? }.sort
  end

  def home_trending_movies(zipcode:, latitude:, longitude:)
    movies = gracenote_movies(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_tz = TimeHelper.local_timezone(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_date = TimeHelper.get_current_local_date(local_tz)

    now_showing_movies = movies.select { |mv| is_now_showing(mv, local_tz, local_date) }
    up_coming_movies = up_coming_months(movies, local_date).map { |ym|
      movies.select { |mv| !is_now_showing(mv, local_tz, local_date) && is_shown_in_month(mv, ym) }
    }.flatten

    serialize_home_trending_containers(dedup_movies(now_showing_movies), dedup_movies(up_coming_movies))
  end

  def home_now_showing_movies(zipcode:, latitude:, longitude:)
    movies = gracenote_movies(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_tz = TimeHelper.local_timezone(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_date = TimeHelper.get_current_local_date(local_tz)
    now_showing_movies = movies.select { |mv| is_now_showing(mv, local_tz, local_date) }

    dedup_movies(now_showing_movies).map { |mv| GracenoteMovieBriefSerializer.new(mv).results }
  end

  def home_up_coming_movies(zipcode:, latitude:, longitude:)
    movies = gracenote_movies(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_tz = TimeHelper.local_timezone(zipcode: zipcode, latitude: latitude, longitude: longitude)
    local_date = TimeHelper.get_current_local_date(local_tz)
    serialize_home_up_coming_containers(movies, local_date, local_tz)
  end

  def get_movie_detail(composite_id:)
    ids = parse_composite_id(composite_id)
    @gracenote_manager.movie_detail(root_id: ids[:rootId], tms_id: ids[:tmsId])
  end

  def celebrity_detail(person_id)
    @gracenote_manager.celebrity_detail(person_id)
  end

  def get_showtimes(composite_id:, zipcode:, latitude:, longitude:)
    ids = parse_composite_id(composite_id)

    movie_showtimes = @gracenote_manager.movie_showtimes(tms_id: ids[:tmsId], zipcode: zipcode, latitude: latitude, longitude: longitude)
    return {} if movie_showtimes.blank?

    theatres = @gracenote_manager.find_theatres(zipcode: zipcode, latitude: latitude, longitude: longitude)

    build_showtime_with_ticket_url(movie: movie_showtimes,
                                   theatres: theatres,
                                   zipcode: zipcode,
                                   latitude: latitude,
                                   longitude: longitude)
  end

  def get_trailer(composite_id)
    ids = parse_composite_id(composite_id)
    trailers = @gracenote_manager.trailers(ids[:rootId])
    return nil if trailers.blank?

    trailer = nil
    for code in Movie::GracenoteApiManager::TRAILER_FORMATS do
      trailer = trailers.find { |t| t['BitrateId'].to_i == code }
      break unless trailer.blank?
    end

    trailer.blank? ? nil : trailer['Url']
  end

  def search_movies(search_term, page = 0, per = 25)
    per = 25 if per.blank?
    page = 0 if page.blank?
    search_rs = @gracenote_manager.search_movies(search_term, page, per)
    {
        total: search_rs['hitCount'].blank? ? 0 : search_rs['hitCount'],
        movies: search_rs['hits'].blank? ? [] : search_rs['hits'].map { |mv| GracenoteMovieSearchSerializer.new(mv['program']).results }
    }
  end

  def get_theatre_detail(id)
    @gracenote_manager.theatre_detail(id)
  end

  private

  def dedup_movies(movies)
    added_root_ids = []
    results = []
    movies.each { |mv|
      unless added_root_ids.include?(mv['rootId'])
        results << mv
        added_root_ids << mv['rootId']
      end
    }
    results
  end

  def parse_composite_id(composite_id)
    ids = composite_id.split('@')
    {
        rootId: ids[0],
        tmsId: ids[1]
    }
  end

  def gracenote_movies(zipcode:, latitude:, longitude:)
    movies = @gracenote_manager.list_playing_movies(zipcode: zipcode, latitude: latitude, longitude: longitude)

    movies.sort { |m1, m2|
      # priority movies with banners
      c_rs = has_banner(m2) <=> has_banner(m1)
      if c_rs == 0
        # recent movie first
        c_rs = m2['releaseDate'] <=> m1['releaseDate']
        if c_rs == 0
          c_rs = quality_ratting(m2) <=> quality_ratting(m1)
          if c_rs == 0
            c_rs = m1['title'] <=> m2['title']
          end
        end
      end
      c_rs
    }
  end

  def quality_ratting(mv)
    GracenoteMoveDetailSerializer::extract_ratings_value(mv)
  end

  def has_banner(mv)
    has = !(mv['preferredImage'].blank? ||
        GracenoteMoveDetailSerializer::is_invalid_image?(mv['preferredImage']['uri']))
    has ? 1 : 0
  end

  def serialize_home_trending_containers(now_showing_movies, up_coming_movies)
    {
        now_showing: now_showing_movies.map { |mv| GracenoteMovieBriefSerializer.new(mv).results.merge({is_now_showing: true}) },
        up_coming: up_coming_movies.map { |mv| GracenoteMovieBriefSerializer.new(mv).results.merge({is_now_showing: false}) },
        single_movie_containers: pick_highlighted_movies(now_showing_movies, up_coming_movies)
    }
  end

  def pick_highlighted_movies(now_showing_movies, up_coming_movies)
    results = []
    now_idx = 0
    up_idx = 0
    added_root_ids = []
    until false
      break if results.length >= NUMBER_OF_HIGHLIGHTED_MOVIES ||
          now_idx >= now_showing_movies.length ||
          up_idx >= up_coming_movies.length

      add_highlighted_movie(results: results, mv: now_showing_movies[now_idx], added_root_ids: added_root_ids, is_now_showing: true)
      add_highlighted_movie(results: results, mv: up_coming_movies[now_idx], added_root_ids: added_root_ids, is_now_showing: false)

      now_idx += 1
      up_idx += 1
    end

    results
  end

  def add_highlighted_movie(results:, mv:, added_root_ids:, is_now_showing:)
    unless GracenoteMoveDetailSerializer::is_invalid_image?(mv)
      unless added_root_ids.include?(mv['rootId'])
        results << GracenoteMovieBriefSerializer.new(mv).results.merge({is_now_showing: is_now_showing})
        added_root_ids << mv['rootId']
      end
    end
  end

  def serialize_home_up_coming_containers(movies, local_date, local_tz)
    # see MoviesContainerSerializer

    up_coming_months(movies, local_date).map { |ym|
      mvs = movies.select { |mv| !is_now_showing(mv, local_tz, local_date) && is_shown_in_month(mv, ym) }
      mvs = dedup_movies(mvs)
      {
          type: 'movies_container',
          id: nil,
          channel_id: nil,
          # ym: 2017-02
          name: "#{Date::MONTHNAMES[ym[5..6].to_i]} #{ym[0..3]}",
          movies: mvs.map { |mv| GracenoteMovieBriefSerializer.new(mv).results },
          width: 'half'
      }
    }
  end

  def up_coming_months(playing_movies_json, local_date)
    current_year_month = "#{local_date.year}-#{local_date.month.to_s.rjust(2, '0')}"
    collect_show_month_year(playing_movies_json).select { |m| m != current_year_month }
  end

  def collect_show_month_year(content_json)
    values = SortedSet.new
    content_json.each { |mv|
      mv['showtimes'].each do |st|
        values << st['dateTime'][0..6]
      end
    }
    values
  end

  def is_now_showing(mv, local_tz, local_date)
    mv['showtimes'].each do |st|
      show = parse_theatre_time(st['dateTime'], local_tz)
      return true if show.year == local_date.year && show.month == local_date.month
    end
    false
  end

  def is_shown_in_month(mv, year_month)
    mv['showtimes'].each do |st|
      return true if st['dateTime'][0..6] == year_month
    end
    false
  end

  def parse_theatre_time(date_time, local_tz)
    # ex: 2017-02-21T19:00
    DateTime.strptime("#{date_time} #{local_tz.name}", '%Y-%m-%dT%H:%M %Z')
  end

  def build_showtime_with_ticket_url(movie:, theatres:, zipcode:, latitude:, longitude:)
    {
        title: movie['title'],
        theatres: build_showtimes(movie: movie, theatres: theatres, zipcode: zipcode, latitude: latitude, longitude: longitude)
    }
  end

  def theatre_address(theatre)
    address = theatre['address']
    return nil if address.blank?
    line = ''
    line = address['street'] unless address['street'].blank?
    line += ", #{address['city']}" unless address['city'].blank?
    line += ", #{address['state']}" unless address['state'].blank?
    line += " #{address['postalCode']}" unless address['postalCode'].blank?
    line
  end

  def theatre_geo(theatre, code)
    return nil if theatre['geoCode'].blank?
    theatre['geoCode'][code]
  end

  def theatre_geo_distance(theatre)
    return nil if theatre['distance'].blank?

    "#{theatre['distance'].to_f.round(2)}#{ENV['MOVIE_SEARCH_DISTANCE_UNIT']}"
  end

  def build_showtimes(movie:, theatres:, zipcode:, latitude:, longitude:)
    theatres_map = {}
    theatres.each do |t|
      theatres_map[t['theatreId']] = t
    end

    showtimes_datetimes = []
    theatres_showtimes = []
    showtimes_map = {}
    movie['showtimes'].select { |st| !st['dateTime'].blank? }.each do |st|
      theatre_id = st['theatre']['id']

      theatre = theatres_map[theatre_id]

      if theatre.blank?
        Rails.logger.warn "theatre_id #{theatre_id} can't be found in list of theatres nearby. Getting its detail separately"
        theatre = get_individual_theatre(theatre_id: theatre_id, zipcode: zipcode, latitude: latitude, longitude: longitude)
        theatres_map[theatre_id] = theatre
      end

      if showtimes_map[theatre_id].blank?
        th_sh = {
            name: theatre['name'],
            address: theatre_address(theatre['location']),
            telephone: theatre['location']['telephone'],
            latitude: theatre_geo(theatre['location'], 'latitude'),
            longitude: theatre_geo(theatre['location'], 'longitude'),
            distance: theatre_geo_distance(theatre['location']),
            showtimes: [],
        }
        showtimes_map[theatre_id] = th_sh
        theatres_showtimes << th_sh
      end

      # gracenote returns duplicate times per theatre
      theatre_datetime = "#{theatre_id}: #{st['dateTime']}"
      unless showtimes_datetimes.include?(theatre_datetime)
        showtimes_datetimes << theatre_datetime
        # "dateTime": "2017-02-23T12:30",
        # "ticketURI": "http://www.fandango.com/tms.asp?t=AAPDQ&m=169821&d=2017-02-23"
        time = st['dateTime'][11..15]
        showtimes_map[theatre_id][:showtimes] << {
            date: st['dateTime'][0..9],
            time: time,
            ticket_url: st['ticketURI'].blank? ? nil : "#{st['ticketURI']}+#{time}",
        }
      end
    end

    theatres_showtimes.sort_by! { |t| t[:distance] }
    theatres_showtimes.each { |t| t[:showtimes].sort! { |s1, s2|
      s1[:date] == s2[:date] ? s1[:time] <=> s2[:time] : s1[:date] <=> s2[:date] } }

    theatres_showtimes
  end

  def get_individual_theatre(theatre_id:, zipcode:, latitude:, longitude:)
    theatre = @gracenote_manager.theatre_detail(theatre_id)

    distance = GeoHelper::geo_distance({zipcode: nil,
                                        latitude: theatre_geo(theatre['location'], 'latitude'),
                                        longitude: theatre_geo(theatre['location'], 'longitude')},
                                       {zipcode: zipcode,
                                        latitude: latitude,
                                        longitude: longitude})
    theatre['location']['distance'] = distance
    theatre
  end

end
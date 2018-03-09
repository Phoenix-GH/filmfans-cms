class GracenotePrefetcher
  include Sidekiq::Worker
  sidekiq_options queue: 'gracenote_prefetcher', retry: 2

  def perform(parameters)
    # {
    #     action: 'all-movie-related-info'
    #     client_ip: @client_ip,
    #     location: {zipcode: zipcode, latitude: latitude, longitude: longitude},
    #     movie_ids: movies.map { |mv| {root_id: mv['rootId'], tms_id: mv['tmsId']} },
    # }

    client_ip = parameters['client_ip']
    params = parameters['params']


    case parameters['action']
      when 'all_movie_related_info'
        all_movie_related_info(client_ip, parameters['location'], parameters['movie_ids'])

      when 'find_theatres'
        find_theatres(client_ip, params)

      when 'movie_detail'
        movie_detail(client_ip, params)

      when 'celebrity_detail'
        celebrity_detail(client_ip, params)

      when 'movie_showtimes'
        movie_showtimes(client_ip, params)

      when 'trailers'
        trailers(client_ip, params)

      when 'theatre_detail'
        theatre_detail(client_ip, params)

      else
        Sidekiq.logger.error "unknown gracenote prefetch action: #{parameters['action']}"
    end
  end

  def all_movie_related_info(client_ip, location, movie_ids)
    return if location.blank?

    GracenotePrefetcher.perform_async(
        {
            action: 'find_theatres',
            client_ip: client_ip,
            params: {zipcode: location['zipcode'], latitude: location['latitude'], longitude: location['longitude']}
        })

    return if movie_ids.blank?

    for ids in movie_ids do
      GracenotePrefetcher.perform_async(
          {
              action: 'movie_detail',
              client_ip: client_ip,
              params: {root_id: ids['root_id'], tms_id: ids['tms_id']}
          })

      GracenotePrefetcher.perform_async(
          {
              action: 'movie_showtimes',
              client_ip: client_ip,
              params: {tms_id: ids['tms_id'], zipcode: location['zipcode'], latitude: location['latitude'], longitude: location['longitude']}
          })

      GracenotePrefetcher.perform_async(
          {
              action: 'trailers',
              client_ip: client_ip,
              params: {root_id: ids['root_id']}
          })
    end
  end

  def find_theatres(client_ip, params)
    Movie::GracenoteApiManager.new(client_ip).find_theatres(zipcode: params['zipcode'],
                                                            latitude: params['latitude'],
                                                            longitude: params['longitude'])
  end

  def movie_detail(client_ip, params)
    movie_detail = Movie::GracenoteApiManager.new(client_ip).movie_detail(root_id: params['root_id'],
                                                                          tms_id: params['tms_id'])
    unless movie_detail.blank? || movie_detail['cast'].blank?
      celebs = movie_detail['cast'].select { |c| !c['characterName'].blank? }
      for c in celebs do
        GracenotePrefetcher.perform_async(
            {
                action: 'celebrity_detail',
                client_ip: client_ip,
                params: {person_id: c['personId']}
            })
      end
    end
  end

  def celebrity_detail(client_ip, params)
    Movie::GracenoteApiManager.new(client_ip).celebrity_detail(params['person_id'])
  end

  def movie_showtimes(client_ip, params)
    zipcode = params['zipcode']
    latitude = params['latitude']
    longitude = params['longitude']

    gracenote_manager = Movie::GracenoteApiManager.new(client_ip)

    movie_with_showtimes = gracenote_manager.movie_showtimes(tms_id: params['tms_id'],
                                                             zipcode: zipcode,
                                                             latitude: latitude,
                                                             longitude: longitude)
    theatres = gracenote_manager.find_theatres(zipcode: zipcode, latitude: latitude, longitude: longitude)

    theatres_ids = theatres.map { |t| t['theatreId'] }

    unless movie_with_showtimes.blank? || movie_with_showtimes['showtimes'].blank?
      movie_with_showtimes['showtimes'].select { |st| !st['ticketURI'].blank? && !st['dateTime'].blank? }.each do |st|
        theatre_id = st['theatre']['id']

        unless theatres_ids.include?(theatre_id)
          GracenotePrefetcher.perform_async(
              {
                  action: 'theatre_detail',
                  client_ip: client_ip,
                  params: {theatre_id: theatre_id}
              })
        end
      end
    end
  end

  def trailers(client_ip, params)
    Movie::GracenoteApiManager.new(client_ip).trailers(params['root_id'])
  end

  def theatre_detail(client_ip, params)
    Movie::GracenoteApiManager.new(client_ip).theatre_detail(params['theatre_id'])
  end

end
class Movie::MovieCacheManager

  def self.read_from_cache(uri)
    cache = MovieApiResultCache.order(updated_at: :desc).find_by(endpoint: uri)
    return nil if cache.blank?

    cache_age = MovieApiCacheAge.find_by(api_type: cache.api_type)
    if cache_age.blank?
      Rails.logger.warn "no max cache age defined in movie_api_cache_ages table for api #{cache.api_type}. " +
                            "Apply default value: #{ENV['MOVIE_API_CACHE_DEF_MAX_AGE_HOUR']} hours"
    end
    max_age_in_hour = cache_age&.age_in_hour
    if max_age_in_hour.blank?
      max_age_in_hour = ENV['MOVIE_API_CACHE_DEF_MAX_AGE_HOUR'].to_i
    end

    if max_age_in_hour < 0
      # no timeout
      return cache.content
    end

    duration_in_secs = (Time.now - cache.updated_at).to_i
    return nil if duration_in_secs > max_age_in_hour * 60 * 60

    cache.content
  end

  def self.update_cache(api_type, uri, response_json, client_ip)
    cache = MovieApiResultCache.order(updated_at: :desc).find_by(endpoint: uri)

    if cache.blank?
      MovieApiResultCache.create(
          {
              endpoint: uri,
              api_type: api_type,
              client_ip: client_ip,
              content: response_json
          })
    else
      cache.update_attributes(
          {
              content: response_json
          })
    end
  end

end
module GeoHelper

  def self.geo_distance(from, to)
    Geokit::default_units = ENV['MOVIE_SEARCH_DISTANCE_UNIT'] == 'mi' ? :miles : :kms

    geo_from = geocode(zipcode: from[:zipcode], latitude: from[:latitude], longitude: from[:longitude])
    geo_to = geocode(zipcode: to[:zipcode], latitude: to[:latitude], longitude: to[:longitude])
    dis = geo_from.distance_to(geo_to)
    dis
  end

  def self.geocode(zipcode:, latitude: nil, longitude: nil)
    if latitude.blank? || longitude.blank?
      if zipcode.blank?
        raise 'Either zipcode or lat/long is required'
      end

      uri = "GoogleGeocoder::zipcode:#{zipcode}"
      cache_geo = Movie::MovieCacheManager::read_from_cache(uri)
      return Marshal.load(Base64.decode64(cache_geo['dump'])) unless cache_geo.blank? || cache_geo['dump'].blank?

      g = Geokit::Geocoders::GoogleGeocoder.geocode(zipcode.to_s)
      Movie::MovieCacheManager::update_cache('GEO_GOOGLE_ZIP', uri, {dump: Base64.encode64(Marshal.dump(g))}, nil)

      return g
    else
      uri = "GoogleGeocoder::lat:#{latitude}::long:#{longitude}"
      cache_geo = Movie::MovieCacheManager::read_from_cache(uri)
      return Marshal.load(Base64.decode64(cache_geo['dump'])) unless cache_geo.blank? || cache_geo['dump'].blank?

      g = Geokit::Geocoders::GoogleGeocoder.reverse_geocode(Geokit::LatLng.new(latitude, longitude))
      Movie::MovieCacheManager::update_cache('GEO_GOOGLE_LATLONG', uri, {dump: Base64.encode64(Marshal.dump(g))}, nil)

      return g
    end
  end
end
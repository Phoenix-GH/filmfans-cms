require 'geokit'
require 'timezone'

module TimeHelper

  def self.current_local_date(zipcode:, latitude:, longitude:)
    local_tz = local_timezone(zipcode: zipcode, latitude: latitude, longitude: longitude)
    get_current_local_date(local_tz)
  end

  def self.get_current_local_date(local_tz)
    local_tz.utc_to_local(Time.now)
  end

  def self.local_timezone(zipcode:, latitude:, longitude:)
    timezone = nil
    begin
      if !(longitude.blank? && latitude.blank?)
        timezone = Timezone.lookup(latitude, longitude)
      elsif !zipcode.blank?
        geo = GeoHelper::geocode(zipcode: zipcode.to_s)
        timezone = Timezone.lookup(geo.lat, geo.lng)
      end
    rescue Exception => e
      LogHelper.log_exception(e)
      timezone = Timezone[ENV['MOVIE_FALLBACK_TIMEZONE']]
    end

    if timezone.blank? || !timezone.valid?
      unless timezone.blank?
        Rails.logger.error "invalid timzone #{timezone}"
      end
      timezone = Timezone[ENV['MOVIE_FALLBACK_TIMEZONE']]
    end

    timezone
  end

end
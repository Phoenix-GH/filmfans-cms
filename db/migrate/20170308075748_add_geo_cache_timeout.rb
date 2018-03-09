class AddGeoCacheTimeout < ActiveRecord::Migration
  def change
    MovieApiCacheAge.create({api_type: 'GEO_GOOGLE_ZIP', age_in_hour: -1})
    MovieApiCacheAge.create({api_type: 'GEO_GOOGLE_LATLONG', age_in_hour: -1})
  end
end

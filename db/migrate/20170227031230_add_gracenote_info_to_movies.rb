class AddGracenoteInfoToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :gracenote_id, :string, null: true, index: true

    MovieApiCacheAge.create({api_type: 'SEARCH_MOVIE', age_in_hour: 4})
  end
end

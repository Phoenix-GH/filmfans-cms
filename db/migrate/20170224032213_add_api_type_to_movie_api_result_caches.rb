class AddApiTypeToMovieApiResultCaches < ActiveRecord::Migration
  def change
    execute <<-SQL
      delete from movie_api_result_caches;
    SQL

    add_column :movie_api_result_caches, :api_type, :string, null: false
    add_index :movie_api_result_caches, [:endpoint, :updated_at]

    create_table :movie_api_cache_ages, id: false, primary_key: :api_type do |t|
      t.string :api_type, null: false
      t.integer :age_in_hour, null: false
    end

    MovieApiCacheAge.create({api_type: 'PLAYING_MOVIES', age_in_hour: -1})
    MovieApiCacheAge.create({api_type: 'MOVIE_DETAIL', age_in_hour: 24 * 30})
    MovieApiCacheAge.create({api_type: 'CELEB_DETAIL', age_in_hour: 24 * 30})
    MovieApiCacheAge.create({api_type: 'THEATRES_BY_GEO', age_in_hour: 24 * 30})
    MovieApiCacheAge.create({api_type: 'SHOWTIMES_BY_MOVIE', age_in_hour: 4})
    MovieApiCacheAge.create({api_type: 'THEATRE_DETAIL', age_in_hour: 24 * 30})
    MovieApiCacheAge.create({api_type: 'TRAILERS_BY_MOVIE', age_in_hour: 24 * 30})
  end
end

class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :showtime_id

      t.string :slug
      t.string :title
      t.string :original_title
      t.string :poster_image_thumbnail
      t.string :synopsist
      t.integer :runtime

      t.text :poster_images
      t.text :scene_images
      t.text :trailers

      t.integer :ratings_imdb_value, :null => false, :default => 0
      t.integer :ratings_imdb_vote_count, :null => false, :default => 0
      t.integer :ratings_tmdb_value, :null => false, :default => 0
      t.integer :ratings_tmdb_vote_count, :null => false, :default => 0

      t.integer :imdb_id
      t.integer :tmdb_id
      t.integer :rentrak_film_id


      t.string :website
      t.string :production_companies

      t.text :keywords
      t.text :release_dates
      t.text :age_limits

      t.timestamps
    end

    add_index :movies, :showtime_id
    add_index :movies, :ratings_imdb_value
    add_index :movies, :ratings_tmdb_value
  end
end

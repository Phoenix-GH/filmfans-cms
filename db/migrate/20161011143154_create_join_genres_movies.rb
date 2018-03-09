class CreateJoinGenresMovies < ActiveRecord::Migration
  def change
    create_table :genres_movies do |t|
      t.integer :genre_id
      t.integer :movie_id
    end
    add_index(:genres_movies, [:genre_id, :movie_id], :unique => true)
  end
end
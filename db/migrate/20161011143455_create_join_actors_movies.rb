class CreateJoinActorsMovies < ActiveRecord::Migration
  def change
    create_table :actors_movies do |t|
      t.integer :actor_id
      t.integer :movie_id
    end
    add_index(:actors_movies, [:actor_id, :movie_id], :unique => true)
  end
end
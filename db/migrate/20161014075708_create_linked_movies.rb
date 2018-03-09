class CreateLinkedMovies < ActiveRecord::Migration
  def change
    create_table :linked_movies do |t|
      t.references :movie, index: true
      t.references :movies_container, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end


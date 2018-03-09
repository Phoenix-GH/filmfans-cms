class CreateMovieProducts < ActiveRecord::Migration
  def change

    create_table :movie_products do |t|
      t.references :movie, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end

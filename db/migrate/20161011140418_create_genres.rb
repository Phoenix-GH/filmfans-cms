class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.integer :showtime_id

      t.string :name

      t.timestamps
    end

    add_index :genres, :showtime_id
  end
end

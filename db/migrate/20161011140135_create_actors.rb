class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :showtime_id

      t.string :character
      t.string :name
      t.string :job

      t.timestamps
    end

    add_index :actors, :showtime_id
  end
end

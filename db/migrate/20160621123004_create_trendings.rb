class CreateTrendings < ActiveRecord::Migration
  def change
    create_table :trendings do |t|
      t.integer :channel_id

      t.timestamps null: false
    end

    add_index :trendings, :channel_id
  end
end

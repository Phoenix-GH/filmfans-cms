class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :media_container_id, index: true
      t.integer :product_id, index: true
      t.decimal :coordinate_x, precision: 4, scale: 3
      t.decimal :coordinate_y, precision: 4, scale: 3
      t.integer :coordinate_duration_end
      t.integer :coordinate_duration_start

      t.timestamps null: false
    end
  end
end

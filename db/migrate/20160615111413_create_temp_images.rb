class CreateTempImages < ActiveRecord::Migration
  def change
    create_table :temp_images do |t|
      t.string :image
      t.text :specification

      t.timestamps null: false
    end
  end
end

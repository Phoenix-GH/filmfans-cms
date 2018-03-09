class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.string :product_code, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end

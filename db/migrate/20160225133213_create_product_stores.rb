class CreateProductStores < ActiveRecord::Migration
  def change
    create_table :product_stores do |t|
      t.decimal :price, precision: 8, scale: 2
      t.string :currency
      t.string :url
      t.integer :product_id, index: true

      t.timestamps null: false
    end
  end
end

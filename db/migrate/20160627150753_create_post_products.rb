class CreatePostProducts < ActiveRecord::Migration
  def change
    create_table :post_products do |t|
      t.integer :post_id
      t.integer :product_id
      t.integer :position

      t.timestamps null: false
    end

    add_index :post_products, :post_id
    add_index :post_products, :product_id
  end
end

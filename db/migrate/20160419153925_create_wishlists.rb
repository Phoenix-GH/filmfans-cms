class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps null: false
    end
    add_index :wishlists, :user_id
    add_index :wishlists, :product_id
  end
end

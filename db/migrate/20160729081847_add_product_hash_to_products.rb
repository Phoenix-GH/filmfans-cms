class AddProductHashToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_hash, :string, index: true
  end
end

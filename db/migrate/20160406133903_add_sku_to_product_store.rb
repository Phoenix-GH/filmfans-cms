class AddSkuToProductStore < ActiveRecord::Migration
  def change
    add_column :product_stores, :sku, :string
  end
end

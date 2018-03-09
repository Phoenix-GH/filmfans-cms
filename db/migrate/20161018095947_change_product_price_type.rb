class ChangeProductPriceType < ActiveRecord::Migration
  def change
    change_column :variant_stores, :sale_price, :decimal, precision: 12, scale: 2
    change_column :variant_stores, :price, :decimal, precision: 12, scale: 2
  end
end

class AddSalePriceToVariantStores < ActiveRecord::Migration
  def change
    add_column :variant_stores, :sale_price, :decimal, precision: 8, scale: 2
  end
end

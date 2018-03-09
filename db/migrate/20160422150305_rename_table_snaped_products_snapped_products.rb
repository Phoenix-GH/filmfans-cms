class RenameTableSnapedProductsSnappedProducts < ActiveRecord::Migration
  def change
    rename_table :snaped_products, :snapped_products
  end
end

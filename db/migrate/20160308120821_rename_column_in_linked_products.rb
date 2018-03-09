class RenameColumnInLinkedProducts < ActiveRecord::Migration
  def change
    rename_column :linked_products, :product_container_id, :products_container_id
  end
end

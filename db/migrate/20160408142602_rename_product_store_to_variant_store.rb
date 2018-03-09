class RenameProductStoreToVariantStore < ActiveRecord::Migration
  def change
    remove_index :product_stores, :product_id
    rename_table :product_stores, :variant_stores
    rename_column :variant_stores, :product_id, :variant_id
    add_index :variant_stores, :variant_id
  end
end

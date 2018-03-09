class AddStoreIdToVariantStores < ActiveRecord::Migration
  def change
    add_column :variant_stores, :store_id, :integer
    add_index :variant_stores, :store_id
  end
end

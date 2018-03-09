class AddMediaOwnerIdToProductsContainers < ActiveRecord::Migration
  def change
    add_column :products_containers, :media_owner_id, :integer
  end
end

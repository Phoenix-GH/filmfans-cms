class AddAdminIdToProductsContainers < ActiveRecord::Migration
  def change
    add_reference :products_containers, :admin, index: true
  end
end

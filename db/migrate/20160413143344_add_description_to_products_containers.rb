class AddDescriptionToProductsContainers < ActiveRecord::Migration
  def change
    add_column :products_containers, :description, :string
  end
end

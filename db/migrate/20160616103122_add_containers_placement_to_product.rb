class AddContainersPlacementToProduct < ActiveRecord::Migration
  def change
    add_column :products, :containers_placement, :boolean, default: true
  end
end

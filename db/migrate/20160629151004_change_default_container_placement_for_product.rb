class ChangeDefaultContainerPlacementForProduct < ActiveRecord::Migration
  def change
    change_column_default(:products, :containers_placement, false)
  end
end

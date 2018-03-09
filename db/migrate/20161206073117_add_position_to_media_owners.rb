class AddPositionToMediaOwners < ActiveRecord::Migration
  def change
    add_column :media_owners, :position, :integer
    add_index :media_owners, [:position, :id]
  end
end

class AddPositionToMagazines < ActiveRecord::Migration
  def change
    add_column :magazines, :position, :integer
    add_index :magazines, [:position, :id]
  end
end

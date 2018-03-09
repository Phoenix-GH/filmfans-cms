class AddPositionToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :position, :integer
    add_index :channels, [:position, :id]
  end
end

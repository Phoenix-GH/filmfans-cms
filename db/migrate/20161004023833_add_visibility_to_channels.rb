class AddVisibilityToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :visibility, :boolean, :default => true
    add_index :channels, :visibility
  end
end

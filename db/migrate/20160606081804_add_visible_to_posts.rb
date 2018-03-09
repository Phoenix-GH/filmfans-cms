class AddVisibleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :visible, :boolean, default: true
  end
end

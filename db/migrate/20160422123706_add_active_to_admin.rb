class AddActiveToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :active, :boolean, default: true
  end
end

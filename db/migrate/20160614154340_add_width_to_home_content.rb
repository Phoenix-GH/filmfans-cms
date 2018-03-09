class AddWidthToHomeContent < ActiveRecord::Migration
  def change
    add_column :home_contents, :width, :string
  end
end

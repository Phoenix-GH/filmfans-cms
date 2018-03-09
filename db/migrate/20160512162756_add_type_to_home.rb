class AddTypeToHome < ActiveRecord::Migration
  def change
    add_column :homes, :home_type, :integer, default: 0
  end
end

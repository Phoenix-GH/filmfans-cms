class AddHiddenToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :hidden, :boolean, default: false
  end
end

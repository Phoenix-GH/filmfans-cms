class AddSizeRequiredToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :size_required, :boolean, default: false
  end
end

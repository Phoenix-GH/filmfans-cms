class AddCategoryHierarchyToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category_hierarchy, :string
  end
end

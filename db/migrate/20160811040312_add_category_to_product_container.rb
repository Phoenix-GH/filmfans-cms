class AddCategoryToProductContainer < ActiveRecord::Migration
  def change
    add_column :products_containers, :category_id, :integer, index: true

    add_foreign_key :products_containers, :categories, on_delete: :cascade, index: true
  end
end

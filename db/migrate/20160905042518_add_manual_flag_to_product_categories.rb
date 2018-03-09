class AddManualFlagToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :manual, :boolean, default: false
  end
end

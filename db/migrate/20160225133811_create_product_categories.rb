class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.integer :product_id, index: true
      t.integer :category_id, index: true

      t.timestamps null: false
    end
  end
end

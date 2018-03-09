class CreateDisneyCategories < ActiveRecord::Migration
  def change
    create_table :disney_categories, id: false do |t|
      t.text :hierarchy, null: false
      t.text :name, null: false
      t.text :image_url, null: false
      t.text :availability, null: false
      t.text :product_name, null: false
      t.text :new_name, null: true
    end

    add_index :disney_categories, [:new_name, :hierarchy]
    add_index :disney_categories, [:hierarchy]
  end
end

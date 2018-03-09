class CreateLinkedProducts < ActiveRecord::Migration
  def change
    create_table :linked_products do |t|
      t.integer :product_container_id
      t.integer :product_id
      t.integer :position

      t.timestamps null: false
    end
  end
end

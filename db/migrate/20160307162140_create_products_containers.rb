class CreateProductsContainers < ActiveRecord::Migration
  def change
    create_table :products_containers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

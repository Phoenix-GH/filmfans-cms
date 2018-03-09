class CreateSnapedProducts < ActiveRecord::Migration
  def change
    create_table :snaped_products do |t|
      t.references :user, index: true
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end

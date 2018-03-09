class CreateProductOptionTypes < ActiveRecord::Migration
  def change
    create_table :product_option_types do |t|
      t.references :product, index: true
      t.references :option_type, index: true

      t.timestamps null: false
    end
  end
end

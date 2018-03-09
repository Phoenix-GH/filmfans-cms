class CreateProductImageCsvExports < ActiveRecord::Migration
  def change
    create_table :product_image_csv_exports do |t|
      t.string :system
      t.string :delta_add_file
      t.integer :delta_add_num, default: 0
      t.string :delta_remove_file
      t.integer :delta_remove_num, default: 0
      t.boolean :running, default: true
      t.boolean :used, default: false
      t.timestamps null: false
    end

    add_index :product_image_csv_exports, :system
    add_index :product_image_csv_exports, [:system, :used]
    add_index :product_image_csv_exports, [:system, :running]
  end
end

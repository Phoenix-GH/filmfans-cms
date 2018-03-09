class AddExportingToProductImageIndex < ActiveRecord::Migration
  def change
    add_column :product_image_index_adds, :in_house_exporting, :integer, null: true, index: true
    add_column :product_image_index_adds, :bb_viz_exporting, :integer, null: true, index: true
    add_column :product_image_index_adds, :ulab_viz_exporting, :integer, null: true, index: true

    add_column :product_image_index_removes, :in_house_exporting, :integer, null: true, index: true
    add_column :product_image_index_removes, :bb_viz_exporting, :integer, null: true, index: true
    add_column :product_image_index_removes, :ulab_viz_exporting, :integer, null: true, index: true
  end
end

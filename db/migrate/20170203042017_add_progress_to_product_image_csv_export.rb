class AddProgressToProductImageCsvExport < ActiveRecord::Migration
  def change
    add_column :product_image_csv_exports, :progress, :string, null: true
  end
end

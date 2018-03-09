class CreateProductImagingIndexSnapshotsTmp < ActiveRecord::Migration
  def change
    create_table :product_imaging_index_snapshots_tmp do |t|
      t.references :product, index: true, foreign_key: true
      t.text :vendor_product_image_url, null: false
      t.references :category, index: true, foreign_key: true
      t.datetime :extracted_date, null: false
      t.boolean :sent, default: false
    end

    add_index :product_imaging_index_snapshots_tmp, [:product_id, :category_id, :extracted_date], unique: true, name: :index_imaging_snapshot_tmp_pid_date
  end
end

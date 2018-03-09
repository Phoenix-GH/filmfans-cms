class AddNameAndBrandToDeltaTables < ActiveRecord::Migration
  def change
    # Add new columns to snapshot tables
    add_column :product_imaging_index_snapshots, :name, :string
    add_column :product_imaging_index_snapshots_tmp, :name, :string
    add_column :product_imaging_index_snapshots, :brand, :string
    add_column :product_imaging_index_snapshots_tmp, :brand, :string
  end
end

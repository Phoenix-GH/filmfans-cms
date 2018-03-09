class AddVendorUrlToSnapshots < ActiveRecord::Migration
  def change
    add_column :product_imaging_index_snapshots, :vendor_url, :string
    add_column :product_imaging_index_snapshots_tmp, :vendor_url, :string
  end
end

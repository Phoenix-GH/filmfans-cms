class AddVendorUrlToProduct < ActiveRecord::Migration
  def change
    add_column :products, :vendor_url, :string
  end
end

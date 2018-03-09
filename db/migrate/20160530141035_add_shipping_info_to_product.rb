class AddShippingInfoToProduct < ActiveRecord::Migration
  def change
    add_column :products, :shipping_info, :string
  end
end

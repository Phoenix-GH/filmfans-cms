class AddQuantityToVariantStore < ActiveRecord::Migration
  def change
    add_column :variant_stores, :quantity, :integer
  end
end

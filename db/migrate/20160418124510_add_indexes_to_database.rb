class AddIndexesToDatabase < ActiveRecord::Migration
  def change
    add_index :variant_stores, :sku
    add_index :option_values, [:option_type_id, :name], unique: true
    remove_column :option_values, :position
    remove_column :option_values, :presentation
    remove_column :option_types, :position
    remove_column :option_types, :presentation
  end
end

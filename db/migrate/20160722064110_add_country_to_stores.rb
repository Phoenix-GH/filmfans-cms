class AddCountryToStores < ActiveRecord::Migration
  def change
    add_column :stores, :country, :jsonb, null: false, default: '[]'
  end
end

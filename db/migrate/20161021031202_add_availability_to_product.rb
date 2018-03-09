class AddAvailabilityToProduct < ActiveRecord::Migration
  def change
    add_column :products, :available, :boolean, default: true, index: true
  end
end

class RemoveIndexCreatedAtFromProducts < ActiveRecord::Migration
  def change
    remove_index :products, :created_at
  end
end

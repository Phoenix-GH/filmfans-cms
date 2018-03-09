class RemovePostIdFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :post_id
  end
end

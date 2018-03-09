class AddIndexToMediaContainer < ActiveRecord::Migration
  def change
    add_index :media_containers, :channel_id
    add_index :products_containers, :channel_id
  end
end

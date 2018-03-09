class AddChannelIdToContainers < ActiveRecord::Migration
  def change
    add_column :products_containers, :channel_id, :integer
    add_column :media_containers, :channel_id, :integer
    add_column :campaigns_containers, :channel_id, :integer
    add_column :campaigns, :channel_id, :integer
  end
end

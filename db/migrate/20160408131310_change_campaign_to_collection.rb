class ChangeCampaignToCollection < ActiveRecord::Migration
  def change
    rename_table :campaigns, :collections
    rename_table :campaign_contents, :collection_contents
    rename_table :linked_campaigns, :linked_collections
    rename_table :campaigns_containers, :collections_containers

    rename_column :collection_contents, :campaign_id, :collection_id
    rename_column :linked_collections, :campaign_id, :collection_id
    rename_column :linked_collections, :campaigns_container_id, :collections_container_id
  end
end

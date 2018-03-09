class CreateLinkedCampaigns < ActiveRecord::Migration
  def change
    create_table :linked_campaigns do |t|
      t.integer :campaigns_container_id
      t.integer :campaign_id
      t.integer :position

      t.timestamps null: false
    end

    add_index :linked_campaigns, :campaigns_container_id
    add_index :linked_campaigns, :campaign_id
  end
end

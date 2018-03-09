class ChangeCampainToCampaign < ActiveRecord::Migration
  def change
    rename_table :campains, :campaigns
    rename_table :campain_contents, :campaign_contents
    rename_column :campaign_contents, :campain_id, :campaign_id
  end
end

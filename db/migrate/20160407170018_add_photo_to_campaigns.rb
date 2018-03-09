class AddPhotoToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :photo, :string
  end
end

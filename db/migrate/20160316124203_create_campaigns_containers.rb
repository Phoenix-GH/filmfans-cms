class CreateCampaignsContainers < ActiveRecord::Migration
  def change
    create_table :campaigns_containers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

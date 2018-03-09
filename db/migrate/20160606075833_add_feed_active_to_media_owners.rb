class AddFeedActiveToMediaOwners < ActiveRecord::Migration
  def change
    add_column :media_owners, :feed_active, :boolean, default: true
  end
end

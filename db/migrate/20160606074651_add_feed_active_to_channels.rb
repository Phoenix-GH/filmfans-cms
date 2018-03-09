class AddFeedActiveToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :feed_active, :boolean, default: true
  end
end

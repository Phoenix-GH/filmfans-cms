class AddIndexToChannelModerators < ActiveRecord::Migration
  def change
    add_index :channel_moderators, :admin_id
    add_index :channel_moderators, :channel_id
  end
end

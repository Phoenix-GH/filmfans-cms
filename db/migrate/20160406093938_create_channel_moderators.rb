class CreateChannelModerators < ActiveRecord::Migration
  def change
    create_table :channel_moderators do |t|
      t.integer :admin_id
      t.integer :channel_id

      t.timestamps null: false
    end
  end
end

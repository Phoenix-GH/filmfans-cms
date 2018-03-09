class CreateChannelMediaOwners < ActiveRecord::Migration
  def change
    create_table :channel_media_owners do |t|
      t.integer :channel_id
      t.integer :media_owner_id

      t.timestamps null: false
    end
    add_index :channel_media_owners, :channel_id
    add_index :channel_media_owners, :media_owner_id
  end
end

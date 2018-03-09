class CreateMediaOwnerModerators < ActiveRecord::Migration
  def change
    create_table :media_owner_moderators do |t|
      t.integer :admin_id
      t.integer :media_owner_id

      t.timestamps null: false
    end
  end
end

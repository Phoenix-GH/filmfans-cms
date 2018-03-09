class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :media_owner_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

class AddFollowedToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :followed_type, :string
    rename_column :followings, :media_owner_id, :followed_id
  end
end

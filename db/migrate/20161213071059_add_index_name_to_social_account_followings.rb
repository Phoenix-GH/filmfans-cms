class AddIndexNameToSocialAccountFollowings < ActiveRecord::Migration
  def change
    add_index :social_account_followings, :name, unique: false
  end
end

class RemoveNameIndexOfSocialAccountFollowings < ActiveRecord::Migration
  def change
    remove_index :social_account_followings, :name
  end
end

class AddSocialAccountRefToSocialAccountFollowings < ActiveRecord::Migration
  def change
    add_reference :social_account_followings, :social_account, index: true, foreign_key: true
  end
end

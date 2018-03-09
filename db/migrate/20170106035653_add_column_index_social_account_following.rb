class AddColumnIndexSocialAccountFollowing < ActiveRecord::Migration
  def change
    add_column :social_account_followings, :ordinal, :integer, index: true, default: 1
  end
end

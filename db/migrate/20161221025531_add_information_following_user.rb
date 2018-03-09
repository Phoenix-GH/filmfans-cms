class AddInformationFollowingUser < ActiveRecord::Migration
  def change
    add_column :social_account_followings, :information, :jsonb, null: true, default: '[]'
  end
end

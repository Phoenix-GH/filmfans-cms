class CreateSocialAccountFollowings < ActiveRecord::Migration
  def change
    create_table :social_account_followings do |t|
      t.string :name
      t.string :avatar_url
      t.string :web_url
      t.string :target_id
      t.timestamps
    end
  end
end

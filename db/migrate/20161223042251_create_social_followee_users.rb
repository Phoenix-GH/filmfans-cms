class CreateSocialFolloweeUsers < ActiveRecord::Migration
  def change
    create_table :social_user_followees do |t|
      t.references :user, index: true
      t.references :social_account_following, index: true

      t.timestamps null: false
    end
  end
end

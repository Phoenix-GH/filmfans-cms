class CreateSocialAccountFollowingCategories < ActiveRecord::Migration
  def change
    create_table :social_account_following_categories do |t|
      t.integer :social_account_following_id, null: false
      t.integer :social_category_id, null: false
      t.timestamps
    end

    add_foreign_key :social_account_following_categories, :social_account_followings
    add_foreign_key :social_account_following_categories, :social_categories
  end
end

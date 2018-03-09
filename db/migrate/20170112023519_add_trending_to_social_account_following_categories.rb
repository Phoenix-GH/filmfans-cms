class AddTrendingToSocialAccountFollowingCategories < ActiveRecord::Migration
  def change
    add_column :social_account_following_categories, :trending, :boolean, null: false, default: false
    add_index :social_account_following_categories, [:trending, :social_category_id], name: :index_social_category_following_trending
  end
end

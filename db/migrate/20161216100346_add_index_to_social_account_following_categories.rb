class AddIndexToSocialAccountFollowingCategories < ActiveRecord::Migration
  def change
    add_index :social_account_following_categories, [:social_account_following_id, :social_category_id], name: 'index_on_following_id_and_category_id'
  end
end

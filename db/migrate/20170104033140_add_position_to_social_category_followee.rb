class AddPositionToSocialCategoryFollowee < ActiveRecord::Migration
  def change
    # category - followee should be unique
    # change the existed index to unique & reorder its columns.
    remove_index :social_account_following_categories, name: 'index_on_following_id_and_category_id', column: [:social_account_following_id, :social_category_id]
    add_index :social_account_following_categories, [:social_category_id, :social_account_following_id], unique: true, name: 'index_social_followees_categories_categoryid_followeeid'

    # support order control on followee list in a category
    add_column :social_account_following_categories, :position, :integer
    add_index :social_account_following_categories, [:social_category_id, :position], name: 'index_social_followees_categories_categoryid_position', order: {:social_category_id => :asc, :position => :desc}
  end
end

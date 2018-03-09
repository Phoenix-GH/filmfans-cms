class AddPositionToCategoryAndFollowings < ActiveRecord::Migration
  def change
    add_column :social_categories, :position, :integer
    add_index :social_categories, [:position, :id]
    add_column :social_account_followings, :position, :integer
    add_index :social_account_followings, [:position, :id]
  end
end

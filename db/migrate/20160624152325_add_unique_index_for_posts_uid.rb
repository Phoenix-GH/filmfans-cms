class AddUniqueIndexForPostsUid < ActiveRecord::Migration
  def change
    add_index :posts, :uid, unique: true
  end
end

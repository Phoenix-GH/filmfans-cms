class AddUidAndPostTypeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :uid, :integer
    add_column :posts, :post_type, :integer
  end
end

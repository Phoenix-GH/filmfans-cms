class AddAuthorToPost < ActiveRecord::Migration
  def change
    add_column :posts, :author_id, :string
    add_column :posts, :author_name, :string
    add_column :posts, :author_url, :string
    add_column :posts, :author_picture_url, :string
  end
end

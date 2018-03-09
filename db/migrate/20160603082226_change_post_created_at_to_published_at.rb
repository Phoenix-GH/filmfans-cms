class ChangePostCreatedAtToPublishedAt < ActiveRecord::Migration
  def change
    rename_column :posts, :post_created_at, :published_at
  end
end

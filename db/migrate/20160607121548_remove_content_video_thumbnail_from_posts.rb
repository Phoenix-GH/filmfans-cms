class RemoveContentVideoThumbnailFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :content_video_thumbnail
    remove_column :posts, :original_video_thumbnail_url
  end

  def down
    add_column :posts, :content_video_thumbnail, :string
    add_column :posts, :original_video_thumbnail_url, :string
  end
end
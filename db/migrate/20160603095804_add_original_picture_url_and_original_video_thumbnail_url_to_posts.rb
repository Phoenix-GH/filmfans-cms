class AddOriginalPictureUrlAndOriginalVideoThumbnailUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_picture_url, :string
    add_column :posts, :original_video_thumbnail_url, :string
  end
end

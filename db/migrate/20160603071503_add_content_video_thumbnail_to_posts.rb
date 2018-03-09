class AddContentVideoThumbnailToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :content_video_thumbnail, :string
  end
end

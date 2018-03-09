class RenameContentVideoUrlToContentVideoForPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :content_video_url, :content_video
  end
end

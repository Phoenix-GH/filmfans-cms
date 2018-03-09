class AddOriginalVideoUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_video_url, :string
  end
end

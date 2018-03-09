class RemoveCoverAndBackgroundImageFromTvShows < ActiveRecord::Migration
  def up
    remove_column :tv_shows, :cover_image
    remove_column :tv_shows, :background_image
  end

  def down
    add_column :tv_shows, :cover_image, :string
    add_column :tv_shows, :background_image, :string
  end
end

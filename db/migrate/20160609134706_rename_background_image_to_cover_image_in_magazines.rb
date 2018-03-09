class RenameBackgroundImageToCoverImageInMagazines < ActiveRecord::Migration
  def change
    rename_column :magazines, :background_image, :cover_image
  end
end

class RemoveCoverImageFromMagazines < ActiveRecord::Migration
  def up
    remove_column :magazines, :cover_image
  end

  def down
    add_column :magazines, :cover_image, :string
  end
end

class RemoveCoverAndBackgroundImageFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :cover_image
    remove_column :events, :background_image
  end

  def down
    add_column :events, :cover_image, :string
    add_column :events, :background_image, :string
  end
end

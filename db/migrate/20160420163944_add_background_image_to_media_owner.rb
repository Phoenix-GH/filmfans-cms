class AddBackgroundImageToMediaOwner < ActiveRecord::Migration
  def change
    add_column :media_owners, :background_image, :string
  end
end

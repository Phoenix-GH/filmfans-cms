class AddCoverImageToMediaContent < ActiveRecord::Migration
  def change
    remove_column :products, :image
    remove_column :media_containers, :image
    add_column :media_contents, :cover_image, :string
  end
end

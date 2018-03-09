class AddZoomAndCropFieldsToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :crop_x,  :integer
    add_column :pictures, :crop_y,  :integer
    add_column :pictures, :width,   :integer
    add_column :pictures, :height,  :integer
    add_column :pictures, :zoom,    :float
  end
end

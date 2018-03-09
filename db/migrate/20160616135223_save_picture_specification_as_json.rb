class SavePictureSpecificationAsJson < ActiveRecord::Migration
  def up
    add_column :pictures, :specification, :text, default: {}.to_json

    remove_column :pictures, :crop_x
    remove_column :pictures, :crop_y
    remove_column :pictures, :width
    remove_column :pictures, :height
    remove_column :pictures, :zoom
  end

  def down
    remove_column :pictures, :specification

    add_column :pictures, :crop_x, :integer
    add_column :pictures, :crop_y, :integer
    add_column :pictures, :width, :integer
    add_column :pictures, :height, :integer
    add_column :pictures, :zoom, :float
  end
end

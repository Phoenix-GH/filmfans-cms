class RemovePictures < ActiveRecord::Migration
  def up
    drop_table :pictures
  end

  def down
    create_table :pictures do |t|
      t.string :file
      t.references :pictureable, polymorphic: true, index: true
      t.string :picture_type
      t.text :specification

      t.timestamps
    end
  end
end

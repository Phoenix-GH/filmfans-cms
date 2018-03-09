class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :file
      t.references :pictureable, polymorphic: true, index: true
      t.string :picture_type
      t.timestamps
    end
  end
end

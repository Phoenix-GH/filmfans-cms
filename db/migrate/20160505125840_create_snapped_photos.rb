class CreateSnappedPhotos < ActiveRecord::Migration
  def change
    create_table :snapped_photos do |t|
      t.references :user, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end

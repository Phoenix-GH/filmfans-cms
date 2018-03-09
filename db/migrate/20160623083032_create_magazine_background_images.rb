class CreateMagazineBackgroundImages < ActiveRecord::Migration
  def change
    create_table :magazine_background_images do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :magazine, index: true, foreign_key: true

      t.timestamps
    end
  end
end

class CreateMagazines < ActiveRecord::Migration
  def change
    create_table :magazines do |t|
      t.references :channel, index: true
      t.string :title
      t.text :description
      t.string :background_image

      t.timestamps null: false
    end
  end
end

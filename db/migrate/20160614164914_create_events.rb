class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :cover_image
      t.string :background_image

      t.timestamps null: false
    end
  end
end

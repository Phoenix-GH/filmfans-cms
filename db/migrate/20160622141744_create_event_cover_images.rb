class CreateEventCoverImages < ActiveRecord::Migration
  def change
    create_table :event_cover_images do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :event, index: true, foreign_key: true

      t.timestamps
    end
  end
end

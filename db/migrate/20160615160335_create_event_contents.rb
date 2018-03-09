class CreateEventContents < ActiveRecord::Migration
  def change
    create_table :event_contents do |t|
      t.references :event, index: true
      t.references :content, polymorphic: true, index: true
      t.integer :position
      t.string :width

      t.timestamps null: false
    end
  end
end

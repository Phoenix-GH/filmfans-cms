class CreateLinkedEvents < ActiveRecord::Migration
  def change
    create_table :linked_events do |t|
      t.references :event, index: true
      t.references :events_container, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end

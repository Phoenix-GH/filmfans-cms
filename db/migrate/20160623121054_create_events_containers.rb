class CreateEventsContainers < ActiveRecord::Migration
  def change
    create_table :events_containers do |t|
      t.string :name
      t.references :channel, index: true

      t.timestamps null: false
    end
  end
end

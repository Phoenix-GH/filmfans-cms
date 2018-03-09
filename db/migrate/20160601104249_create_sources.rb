class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.references :media_owner, index: true

      t.string :name
      t.integer :dialogfeed_id
      t.string :website

      t.timestamps null: false
    end
  end
end

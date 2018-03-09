class CreateHomeContents < ActiveRecord::Migration
  def change
    create_table :home_contents do |t|
      t.integer :home_id
      t.integer :content_id
      t.integer :position
      t.string :content_type

      t.timestamps null: false
    end

    add_index :home_contents, :home_id
    add_index :home_contents, [:content_id, :content_type]
  end
end

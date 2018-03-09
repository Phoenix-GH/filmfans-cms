class CreateCampainContents < ActiveRecord::Migration
  def change
    create_table :campain_contents do |t|
      t.integer :campain_id
      t.integer :content_id
      t.string :content_type
      t.integer :position

      t.timestamps null: false
    end
  end
end

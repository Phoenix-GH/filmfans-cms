class CreateTrendingContents < ActiveRecord::Migration
  def change
    create_table :trending_contents do |t|
      t.integer :trending_id
      t.integer :content_id
      t.string :content_type
      t.integer :position
      t.string :width

      t.timestamps null: false
    end

    add_index :trending_contents, :trending_id
    add_index :trending_contents, [:content_id, :content_type]
  end
end

class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.references :tv_show, index: true
      t.string :cover_image
      t.string :file
      t.string :title
      t.integer :season
      t.integer :number
      t.text :specification

      t.timestamps null: false
    end
  end
end

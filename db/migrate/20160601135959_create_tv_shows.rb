class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
      t.references :channel, index: true
      t.string :cover_image
      t.string :title
      t.text :description
      t.string :background_image

      t.timestamps null: false
    end
  end
end


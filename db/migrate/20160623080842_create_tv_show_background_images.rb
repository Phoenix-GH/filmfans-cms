class CreateTvShowBackgroundImages < ActiveRecord::Migration
  def change
    create_table :tv_show_background_images do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :tv_show, index: true, foreign_key: true

      t.timestamps
    end
  end
end

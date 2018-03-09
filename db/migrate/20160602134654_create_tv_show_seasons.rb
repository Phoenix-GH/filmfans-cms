class CreateTvShowSeasons < ActiveRecord::Migration
  def change
    create_table :tv_show_seasons do |t|
      t.references :tv_show, index: true
      t.integer :number

      t.timestamps null: false
    end
  end
end

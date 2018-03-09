class CreateMoviesContainers < ActiveRecord::Migration
  def change
    create_table :movies_containers do |t|
      t.string :name
      t.references :channel, index: true
      t.references :admin, index: true

      t.timestamps null: false
    end
  end
end

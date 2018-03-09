class CreateMediaContainers < ActiveRecord::Migration
  def change
    create_table :media_containers do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps null: false
    end
  end
end

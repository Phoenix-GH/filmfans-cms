class CreateCampains < ActiveRecord::Migration
  def change
    create_table :campains do |t|
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end

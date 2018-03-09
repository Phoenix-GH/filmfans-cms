class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end

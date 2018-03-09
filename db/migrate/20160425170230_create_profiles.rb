class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :name
      t.string :surname
      t.string :picture

      t.timestamps null: false
    end
  end
end

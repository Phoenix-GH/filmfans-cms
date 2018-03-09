class CreateMediaOwners < ActiveRecord::Migration
  def change
    create_table :media_owners do |t|
      t.string :name
      t.string :picture
      t.string :usrl

      t.timestamps null: false
    end
  end
end

class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true
      t.string :label
      t.string :city
      t.string :street
      t.string :zip_code
      t.string :country

      t.timestamps null: false
    end
  end
end

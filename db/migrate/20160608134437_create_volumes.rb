class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.references :magazine, index: true
      t.integer :year
      t.integer :number

      t.timestamps null: false
    end
  end
end

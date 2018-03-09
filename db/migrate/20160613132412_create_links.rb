class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :target_type
      t.references :target, index: true

      t.timestamps null: false
    end
  end
end

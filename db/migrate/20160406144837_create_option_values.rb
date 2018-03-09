class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :option_type, index: true
      t.string :name
      t.string :presentation
      t.integer :position

      t.timestamps null: false
    end
  end
end

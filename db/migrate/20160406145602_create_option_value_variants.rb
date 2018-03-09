class CreateOptionValueVariants < ActiveRecord::Migration
  def change
    create_table :option_value_variants do |t|
      t.references :option_value, index: true
      t.references :variant, index: true

      t.timestamps null: false
    end
  end
end

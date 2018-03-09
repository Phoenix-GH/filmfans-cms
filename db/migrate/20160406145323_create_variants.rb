class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end

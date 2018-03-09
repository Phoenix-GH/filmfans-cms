class CreateRelatedProducts < ActiveRecord::Migration
  def change
    create_table :related_products do |t|
      t.integer :related_from_id, index: true
      t.integer :related_to_id, index: true

      t.timestamps null: false
    end
  end
end

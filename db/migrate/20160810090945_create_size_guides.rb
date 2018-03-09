class CreateSizeGuides < ActiveRecord::Migration
  def change
    create_table :size_guides do |t|
      t.references :category, index: true, foreign_key: {on_delete: :cascade}
      t.string :size_name, null: false
      t.string :size_num, null: false
      t.string :country
    end

  end
end

class CreateSocialCategories < ActiveRecord::Migration
  def change
    create_table :social_categories do |t|
      t.string :name, null: false
      t.string :image
      t.boolean :visible, null: false, default: true
      t.timestamps
    end

    add_index :social_categories, :name, unique: false
  end
end

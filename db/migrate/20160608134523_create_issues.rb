class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.references :volume, index: true
      t.integer :number
      t.integer :pages
      t.string :url
      t.string :cover_image
      t.text :description

      t.timestamps null: false
    end
  end
end

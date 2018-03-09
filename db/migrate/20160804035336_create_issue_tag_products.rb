class CreateIssueTagProducts < ActiveRecord::Migration
  def change
    create_table :issue_tag_products do |t|
      t.references :product, index: true, foreign_key: true
      t.references :issue_page_tag, index: true, foreign_key: true
      t.integer :position
      
      t.timestamps null: false
    end
  end
end

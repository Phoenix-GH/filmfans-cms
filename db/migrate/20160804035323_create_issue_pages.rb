class CreateIssuePages < ActiveRecord::Migration
  def change
    create_table :issue_pages do |t|
      t.integer :page_number
      t.string :description
      t.string :image
      t.references :issue, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :issue_pages, [:issue_id, :page_number], :unique => true
  end
end

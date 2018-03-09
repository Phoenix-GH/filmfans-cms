class CreateIssuePageTags < ActiveRecord::Migration
  def change
    create_table :issue_page_tags do |t|
      t.text :specification, default: {}.to_json
      t.references :issue_page, index: true, foreign_key: true

      t.timestamps
    end
  end
end

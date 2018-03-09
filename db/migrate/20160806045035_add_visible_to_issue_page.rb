class AddVisibleToIssuePage < ActiveRecord::Migration
  def change
    add_column :issue_pages, :visible, :boolean, default: true
  end
end

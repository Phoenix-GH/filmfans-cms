class ChangeColumnsInIssues < ActiveRecord::Migration
  def change
    remove_column :volumes, :number
    remove_column :issues, :number
    add_column :issues, :publication_date, :date
  end
end

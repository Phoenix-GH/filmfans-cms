class RemoveCoverImageFromIssues < ActiveRecord::Migration
  def up
    remove_column :issues, :cover_image
  end

  def down
    add_column :issues, :cover_image, :string
  end
end

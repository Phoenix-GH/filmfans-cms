class RenameColumnInMediaOwner < ActiveRecord::Migration
  def change
    rename_column :media_owners, :usrl, :url
  end
end

class RenameMediaContentColumn < ActiveRecord::Migration
  def change
    rename_column :media_contents, :type, :file_type
  end
end

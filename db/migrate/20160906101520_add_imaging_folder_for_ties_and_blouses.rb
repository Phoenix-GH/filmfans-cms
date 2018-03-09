class AddImagingFolderForTiesAndBlouses < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set imaging_category = 'tie' where id = 171;
      UPDATE categories set imaging_category = 'woman_blouse' where id = 172;
    SQL
  end
end

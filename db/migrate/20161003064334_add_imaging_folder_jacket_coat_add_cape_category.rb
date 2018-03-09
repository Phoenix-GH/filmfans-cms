class AddImagingFolderJacketCoatAddCapeCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
      (199, 'Capes', 67, NULL, 3, FALSE, now(), now(), false, 'Woman > Accessories > Capes');

      UPDATE categories SET imaging_category = 'woman_jacket' where id = 166;
      UPDATE categories SET imaging_category = 'man_jacket' where id = 164;
      UPDATE categories SET imaging_category = 'woman_suit' where id = 162;

    SQL
  end
end

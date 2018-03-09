class AddNewImagingCategories < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO categories(id, name, icon, image, parent_id, imaging_category, level, unisex, created_at, updated_at) VALUES
      (163, 'Jackets', null, null, 41, null, 2, TRUE, now(), now()),
      (164, 'Jackets', null, null, 163, null, 3, TRUE, now(), now()),
      (165, 'Jackets', null, null, 40, null, 2, TRUE, now(), now()),
      (166, 'Jackets', null, null, 165, null, 3, TRUE, now(), now());
    SQL
  end
end

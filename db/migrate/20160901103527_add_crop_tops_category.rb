class AddCropTopsCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
          (173, 'Crop tops', 40, NULL, 2, FALSE, now(), now(), false, 'Woman > Crop tops'),
          (174, 'Crop tops', 173, NULL, 3, FALSE, now(), now(), true, 'Woman > Crop tops');
    SQL
  end
end

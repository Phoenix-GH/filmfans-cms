class AddManClutchBagAndChangCapesParent < ActiveRecord::Migration
  def change
    execute <<-SQL

      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
      (200, 'Capes', 40, NULL, 2, FALSE, now(), now(), false, 'Woman > Capes'),
      (201, 'Clutch Bags', 177, NULL, 3, TRUE, now(), now(), false, 'Man > Bags > Clutch Bags');

      -- capes is in its own category, no parent
      UPDATE categories SET parent_id = 200, display_name = 'Woman > Capes' where id = 199;

      -- clutch bag is unisex
      UPDATE categories SET unisex = TRUE where id = 185;

    SQL
  end
end

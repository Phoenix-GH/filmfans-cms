class AddOpticalGlassesCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
      -- fix mistake man > sunglasses
      update categories set size_required = false where id = 120;

      update categories set name = 'Glasses', display_name = 'Man > Glasses' where id = 64;
      update categories set name = 'Glasses', display_name = 'Woman > Glasses' where id = 73;

      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, hidden, display_name) VALUES
      (204, 'Glasses & Frames', 64, NULL, 3, true, now(), now(), false, true, 'Man > Glasses > Glasses & Frames'),
      (205, 'Glasses & Frames', 73, NULL, 3, true, now(), now(), false, true, 'Woman > Glasses > Glasses & Frames');
    SQL
  end
end

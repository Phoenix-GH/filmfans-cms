class AddManRingCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, hidden, display_name) VALUES
      (206, 'Rings', 59, NULL, 3, true, now(), now(), true, true, 'Man > Accessories > Rings');
    SQL
  end
end

class AddChukkaCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
          (197, 'Chukka', 52, NULL, 3, FALSE, now(), now(), true, 'Man > Shoes > Chukka'),
          (198, 'Chukka', 71, NULL, 3, FALSE, now(), now(), true, 'Woman > Shoes > Chukka');
    SQL
  end
end

class AddNewBagCategories < ActiveRecord::Migration
  def change
    execute <<-SQL
    INSERT INTO categories
      (id, name, parent_id, display_name, imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (222, 'Chest bags', 177, 'Man > Bags > Chest bags', NULL, 3, false, false, true, now(), now()),
      (223, 'Waist bags', 177, 'Man > Bags > Waist bags', NULL, 3, false, false, true, now(), now());
    SQL
  end
end

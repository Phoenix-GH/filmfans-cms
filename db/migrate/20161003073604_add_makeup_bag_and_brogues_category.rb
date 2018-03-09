class AddMakeupBagAndBroguesCategory < ActiveRecord::Migration
  def change
    execute <<-SQL

      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
      (202, 'Make-up bags', 82, NULL, 3, FALSE, now(), now(), false, 'Woman > Bags > Make-up bags'),
      (203, 'Brogues & Oxfords', 71, NULL, 3, FALSE, now(), now(), true, 'Woman > Shoes > Brogues & Oxfords');
    SQL
  end
end

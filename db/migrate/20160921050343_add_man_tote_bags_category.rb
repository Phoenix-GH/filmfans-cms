class AddManToteBagsCategory < ActiveRecord::Migration
  def change
    execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
          (196, 'Tote bags', 177, NULL, 3, FALSE, now(), now(), false, 'Man > Bags > Tote bags');
    SQL
  end
end

class ChangeBagsAndDressesCategories < ActiveRecord::Migration
  def change
    execute <<-SQL

      UPDATE categories set name = 'Messenger bags', display_name = 'Man > Accessories > Messenger bags' where id = 105;
      UPDATE categories set name = 'Messenger bags', display_name = 'Woman > Accessories > Messenger bags' where id = 127;

      INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
        (175, 'Tote bags', 40, NULL, 2, FALSE, now(), now(), false, 'Woman > Tote bags'),
        (176, 'Tote bags', 175, NULL, 3, FALSE, now(), now(), false, 'Woman > Tote bags');

    SQL
  end
end

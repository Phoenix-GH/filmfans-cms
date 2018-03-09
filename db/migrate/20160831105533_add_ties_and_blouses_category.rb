class AddTiesAndBlousesCategory < ActiveRecord::Migration
  def change
    say_with_time 'Add new Blouse and Ties category' do
      execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required, display_name) VALUES
          (169, 'Ties', 41, NULL, 2, FALSE, now(), now(), false, 'Man > Ties'),
          (170, 'Blouses', 40, NULL, 2, FALSE, now(), now(), false, 'Women > Blouses'),
          (171, 'Ties', 169, NULL, 3, FALSE, now(), now(), false, 'Man > Ties'),
          (172, 'Blouses', 170, NULL, 3, FALSE, now(), now(), true, 'Women > Blouses');
      SQL
    end
  end
end

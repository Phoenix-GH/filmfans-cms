class AddCategoryWomenSuit < ActiveRecord::Migration
  def change
    say_with_time 'Rename Women Vest to Suit' do
      execute <<-SQL
        UPDATE categories
        SET name = 'Suits', imaging_category = NULL
        WHERE id IN (88, 162);
      SQL
    end

    say_with_time 'Add new Vest category for Women' do
      execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required) VALUES
          (167, 'Vests', 40, NULL, 2, FALSE, now(), now(), false),
          (168, 'Vests', 167, 'woman_vest', 3, FALSE, now(), now(), true);
      SQL
    end

  end
end

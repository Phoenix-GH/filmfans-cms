class AddNewCategories < ActiveRecord::Migration
  def change

    say_with_time 'Add new categories' do
      execute <<-SQL
        INSERT INTO categories(id, name, parent_id, imaging_category, level, unisex, created_at, updated_at, size_required) VALUES
          -- Level 2
          (177, 'Bags', 41, NULL, 2, FALSE, now(), now(), false),
          (178, 'Cardigans', 40, NULL, 2, FALSE, now(), now(), false),
          (179, 'Cardigans', 41, NULL, 2, FALSE, now(), now(), false),
          (180, 'Bodysuits', 40, NULL, 2, FALSE, now(), now(), false),
          (181, 'Hats & Caps', 40, NULL, 2, FALSE, now(), now(), false),
          (182, 'Hats & Caps', 41, NULL, 2, FALSE, now(), now(), false),

          -- Level 3
          (183, 'Backpacks', 82, NULL, 3, TRUE, now(), now(), false),
          (184, 'Backpacks', 177, NULL, 3, TRUE, now(), now(), false),
          (185, 'Clutch Bags', 82, NULL, 3, FALSE, now(), now(), false),
          (186, 'Cardigans', 178, NULL, 3, TRUE, now(), now(), false),
          (187, 'Cardigans', 179, NULL, 3, TRUE, now(), now(), false),
          (188, 'Beanies', 181, NULL, 3, TRUE, now(), now(), false),
          (189, 'Beanies', 182, NULL, 3, TRUE, now(), now(), false),
          (190, 'Rings', 67, NULL, 3, FALSE, now(), now(), true),
          (191, 'Scarfs', 59, NULL, 3, TRUE, now(), now(), false),
          (192, 'Scarfs', 67, NULL, 3, TRUE, now(), now(), false),
          (193, 'Gloves', 59, NULL, 3, TRUE, now(), now(), false),
          (194, 'Gloves', 67, NULL, 3, TRUE, now(), now(), false),
          (195, 'Bodysuits', 180, NULL, 3, FALSE, now(), now(), true)
      SQL
    end

    say_with_time 'Update bags and hats' do
      execute <<-SQL
        --
        UPDATE categories
        SET parent_id = 177
        WHERE id = 105;

        UPDATE categories
        SET parent_id = 82
        WHERE id = 127;

        UPDATE categories
        SET parent_id = 82
        WHERE id = 156;

        -- Woman hat
        UPDATE categories
        SET parent_id = 181
        WHERE id = 126;

        -- Man hat
        UPDATE categories
        SET parent_id = 182
        WHERE id = 104;

        -- Woman Baseball caps
        UPDATE categories
        SET parent_id = 181
        WHERE id = 123;

        -- Man Baseball caps
        UPDATE categories
        SET parent_id = 182
        WHERE id = 101;


      SQL
    end

    say_with_time 'Update display name' do
      #   Update display name for level 2
      execute <<-SQL
      UPDATE categories c
      SET display_name = name_result.display_name
      FROM (
             SELECT
               c1.id,
               concat(c2.name, ' > ', c1.name
               ) AS display_name
             FROM
               categories c1
               INNER JOIN categories c2 ON c1.parent_id = c2.id
             WHERE
               c1.level = 2
             ORDER BY c2.name, c1.name ASC) AS name_result
      WHERE
        c.id = name_result.id
        AND c.id>166;
      SQL

      #   Update display name for level 3
      execute <<-SQL
      UPDATE categories c set display_name=name_result.display_name
      FROM (
      SELECT
        c1.id,
        concat(c3.name, ' > ', c2.name,
               (SELECT concat(' > ', cx.name)
                FROM categories cx
                WHERE cx.id = c1.id AND cx.name <> c2.name
               )
        ) as display_name
      FROM
        categories c1
        INNER JOIN categories c2 ON c1.parent_id = c2.id
        INNER JOIN categories c3 ON c2.parent_id = c3.id
      WHERE
        c1.level = 3
        AND c2.level = 2
      ORDER BY c3.name, c2.name, c1.name ASC) AS name_result
      WHERE
        c.id=name_result.id
        AND (c.id>166 OR c.id IN (105, 127, 156, 126, 104, 123, 101))
      SQL
    end
  end
end

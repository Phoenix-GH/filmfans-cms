class AddDisplayNameToCategories < ActiveRecord::Migration
  def up

    #   Add Column display name to table categories
    add_column :categories, :display_name, :string


    # Update level 1
    execute <<-SQL
      UPDATE categories c SET level=1 WHERE id in(40, 41);
    SQL

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
        c.id = name_result.id;
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
      ORDER BY c3.name, c2.name, c1.name ASC) as name_result
      WHERE
        c.id=name_result.id;
    SQL
  end


  def down
    remove_column :categories, :display_name, :string
  end

end

class AddQuarantineCategoryUpdateDressName < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE categories set name = 'Casual Dresses' where id = 146;
      UPDATE categories set name = 'Club Dresses' where id = 147;
      UPDATE categories set name = 'Formal Dresses' where id = 148;

        INSERT INTO categories(id, name,  level, unisex, created_at, updated_at, display_name) VALUES
          (48, 'Quarantine products', 1, TRUE, now(), now(), 'Quarantine products');
    SQL
  end
end

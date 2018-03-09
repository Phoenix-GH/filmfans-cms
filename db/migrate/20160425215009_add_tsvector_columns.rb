class AddTsvectorColumns < ActiveRecord::Migration
  def up
    add_column :products, :tsv, :tsvector
    add_index :products, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON products FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE products SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON products
    SQL

    remove_index :products, :tsv
    remove_column :products, :tsv
  end
end

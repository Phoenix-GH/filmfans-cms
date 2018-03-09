class AddNameTsvIndexToSocialAccountFollowings < ActiveRecord::Migration
  def up
    add_column :social_account_followings, :tsv, :tsvector
    add_index :social_account_followings, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON social_account_followings FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', name
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE social_account_followings SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON social_account_followings
    SQL

    remove_index :social_account_followings, :tsv
    remove_column :social_account_followings, :tsv
  end
end

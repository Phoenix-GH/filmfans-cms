class ModifyForeignKeyAndSequencesForReimport < ActiveRecord::Migration
  def change

    say_with_time 'Drop TSV trigger' do
      execute <<-SQL
        DROP TRIGGER IF EXISTS tsvectorupdate
        ON products CASCADE
      SQL
    end

    # Drop sequences on stores and affiliates
    execute <<-SQL
      DROP SEQUENCE stores_id_seq cascade;
      DROP SEQUENCE affiliates_id_seq cascade;
    SQL

    # Reset product relative sequences to 5k
    execute <<-SQL
      ALTER SEQUENCE products_id_seq RESTART WITH 50;
      ALTER SEQUENCE product_categories_id_seq RESTART WITH 50;
      ALTER SEQUENCE product_files_id_seq RESTART WITH 50;
      ALTER SEQUENCE product_option_types_id_seq RESTART WITH 50;
      ALTER SEQUENCE product_similarity_id_seq RESTART WITH 50;
      ALTER SEQUENCE products_containers_id_seq RESTART WITH 50;
      ALTER SEQUENCE variants_id_seq RESTART WITH 50;
      ALTER SEQUENCE variant_stores_id_seq RESTART WITH 50;
      ALTER SEQUENCE variant_files_id_seq RESTART WITH 50;
      ALTER SEQUENCE option_value_variants_id_seq RESTART WITH 50;
    SQL

    # Create new foreign keys
    say_with_time 'Create new foreign keys' do
      add_foreign_key :product_categories, :products, index: true
      add_foreign_key :product_files, :products, index: true
      add_foreign_key :product_categories, :categories, index: true
      add_foreign_key :variant_stores, :stores, index: true
      add_foreign_key :variant_stores, :variants, index: true
      add_foreign_key :variant_files, :variants, index: true
      add_foreign_key :variants, :products, index: true
      add_foreign_key :option_value_variants, :variants, index: true
      add_foreign_key :option_value_variants, :option_values, index: true
      add_foreign_key :option_values, :option_types, index: true
    end

  end
end

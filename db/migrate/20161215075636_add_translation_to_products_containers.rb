class AddTranslationToProductsContainers < ActiveRecord::Migration
  def change
    create_table :supported_languages do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
            INSERT INTO supported_languages(code, name) VALUES
            ('en', 'English'),
            ('ko', 'Korean'),
            ('ms', 'Malay'),
            ('vi', 'Vietnamese'),
            ('th', 'Thai'),
            ('zh', 'Chinese');
          SQL
      end

      dir.down do
      end
    end


    add_column :products_containers, :translation, :json, null: false, default: '{}'
  end

  def up

  end
end

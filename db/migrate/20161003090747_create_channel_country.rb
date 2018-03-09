class CreateChannelCountry < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text :name, null: false
      t.text :code, null: false
    end

    add_column :channels, :countries, :jsonb, null: false, default: '[]'
    # jsonb index on array type
    add_index :channels, :countries, using: :gin

    execute <<-SQL
      INSERT INTO countries(id, name, code) VALUES
        (1, 'China', 'cn'),
        (2, 'Indonesia', 'id'),
        (3, 'Korea', 'kp'),
        (4, 'Malaysia', 'my'),
        (5, 'Philippines', 'ph'),
        (6, 'Singapore', 'sg'),
        (7, 'Thailand', 'th')
    SQL
  end
end

class AddKeyToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :key, :string, :unique => true
    execute <<-SQL
    INSERT INTO channels
      (name, key, dialogfeed_url, created_at, updated_at) VALUES
      ('#HOTSPOTME', 'HOTSPOTME', '', now(), now())
    SQL
  end
end

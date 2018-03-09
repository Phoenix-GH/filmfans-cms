class AddUrlsToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :small_version_url, :string
    add_column :media_contents, :normal_version_url, :string
    add_column :media_contents, :large_version_url, :string
  end
end

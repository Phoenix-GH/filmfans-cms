class RemoveUrlsFromMediaContent < ActiveRecord::Migration
  def change
    remove_column :media_contents, :large_version_url, :string
    remove_column :media_contents, :normal_version_url, :string
    remove_column :media_contents, :small_version_url, :string
  end
end

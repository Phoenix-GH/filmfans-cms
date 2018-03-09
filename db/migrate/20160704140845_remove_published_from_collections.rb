class RemovePublishedFromCollections < ActiveRecord::Migration
  def up
    remove_column :collections, :published
  end

  def down
    add_column :collections, :published, :boolean
  end
end

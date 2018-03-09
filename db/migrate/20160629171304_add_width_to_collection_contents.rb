class AddWidthToCollectionContents < ActiveRecord::Migration
  def change
    add_column :collection_contents, :width, :string
  end
end

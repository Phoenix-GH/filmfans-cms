class ChangeSourcesAssociationToPolymorphic < ActiveRecord::Migration
  def up
    remove_reference :sources, :media_owner

    add_column :sources, :source_owner_id, :integer, index: true
    add_column :sources, :source_owner_type, :string
  end

  def down
    add_reference :sources, :media_owner, index: true

    remove_column :sources, :source_owner_id, :integer
    remove_column :sources, :source_owner_type, :string
  end
end

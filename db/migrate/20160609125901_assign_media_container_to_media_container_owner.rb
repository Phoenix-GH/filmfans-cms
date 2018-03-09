class AssignMediaContainerToMediaContainerOwner < ActiveRecord::Migration
  def up
    remove_column :media_containers, :channel_id
    remove_column :media_containers, :media_owner_id

    add_column :media_containers, :owner_id, :integer, index: true
    add_column :media_containers, :owner_type, :string
  end

  def down
    add_column :media_containers, :channel_id, :integer
    add_column :media_containers, :media_owner_id, :integer

    remove_column :media_containers, :owner_id
    remove_column :media_containers, :owner_type
  end
end

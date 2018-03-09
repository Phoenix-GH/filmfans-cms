class AddMediaOwnerIdToMediaContainer < ActiveRecord::Migration
  def change
    add_column :media_containers, :media_owner_id, :integer
  end
end

class AddAdminIdToCollectionsContainers < ActiveRecord::Migration
  def change
    add_reference :collections_containers, :admin, index: true
  end
end

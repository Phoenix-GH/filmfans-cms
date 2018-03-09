class AddAdminIdToEventsContainers < ActiveRecord::Migration
  def change
    add_reference :events_containers, :admin, index: true
  end
end

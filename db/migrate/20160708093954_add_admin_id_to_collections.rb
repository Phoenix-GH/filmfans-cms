class AddAdminIdToCollections < ActiveRecord::Migration
  def change
    add_reference :collections, :admin, index: true
  end
end

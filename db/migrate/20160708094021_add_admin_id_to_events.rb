class AddAdminIdToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :admin, index: true
  end
end

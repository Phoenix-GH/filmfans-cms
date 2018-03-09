class AddDialogfeedUrlToMediaOwners < ActiveRecord::Migration
  def change
    add_column :media_owners, :dialogfeed_url, :string
  end
end

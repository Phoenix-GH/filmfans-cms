class AddDialogfeedUrlToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :dialogfeed_url, :string
  end
end

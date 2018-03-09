class AddSeedsDataToStores < ActiveRecord::Migration
  def up
    Store.find_or_create_by(
      name: 'Manually added products'
    )
  end
end

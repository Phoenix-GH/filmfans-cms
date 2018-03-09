class AddUlabUserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :ulab_user_id, :string
  end
end

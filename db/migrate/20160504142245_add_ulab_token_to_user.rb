class AddUlabTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :ulab_access_token, :string
  end
end

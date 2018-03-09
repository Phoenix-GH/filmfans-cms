class AddUserProfilePicture < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture, :string
    rename_column :users, :username, :name
    add_column :users, :surname, :string
  end
end

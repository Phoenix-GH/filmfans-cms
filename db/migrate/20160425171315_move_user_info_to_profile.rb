class MoveUserInfoToProfile < ActiveRecord::Migration
  def change
    User.find_each do |user|
      profile = user.create_profile
      profile.name = user.name
      profile.surname = user.surname
      profile.picture = user.profile_picture
    end

    remove_column :users, :name
    remove_column :users, :surname
    remove_column :users, :profile_picture
  end
end

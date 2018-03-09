class AddSexBirthdayToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :sex, :string
    add_column :profiles, :birthday, :date
  end
end

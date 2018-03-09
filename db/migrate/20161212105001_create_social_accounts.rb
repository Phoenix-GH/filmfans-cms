class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :name
      t.string :provider
      t.string :username
      t.text :password
      t.timestamps
    end

    add_index :social_accounts, [:username, :provider], unique: true
  end
end

class AddSocialCategorySponsored < ActiveRecord::Migration
  def change
    SocialCategory.create!({name: 'Sponsored', is_top: true})
  end
end

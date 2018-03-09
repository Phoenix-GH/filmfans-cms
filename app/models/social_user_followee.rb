class SocialUserFollowee < ActiveRecord::Base
  belongs_to :user
  belongs_to :social_account_following
end

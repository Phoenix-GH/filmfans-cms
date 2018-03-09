class SocialAccountFollowingCategory < ActiveRecord::Base
  belongs_to :social_account_following
  belongs_to :social_category
end

class SocialAccount < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  has_many :social_account_followings, dependent: :delete_all

  classy_enum_attr :provider, default: "instagram"

  def total_following
    social_account_followings.count
  end
end

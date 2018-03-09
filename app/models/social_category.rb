class SocialCategory < ActiveRecord::Base
  mount_uploader :image, PictureUploader

  has_many :social_account_following_categories, dependent: :destroy
  has_many :social_account_followings, through: :social_account_following_categories

  before_destroy :prevent_destroy_top_cat

  private
  def prevent_destroy_top_cat
    if is_top
      Rails.logger.error("Wrong destroy! Top category cannot be destroyed.")
      throw(:abort)
    end
  end
end

class ThreedAr < ActiveRecord::Base
  has_many :threed_models, dependent: :destroy

  mount_uploader :image, PictureUploader

  def trigger_image_url
    image.full_url
  end

  def thumb_url
    image.full_thumb_url
  end
end
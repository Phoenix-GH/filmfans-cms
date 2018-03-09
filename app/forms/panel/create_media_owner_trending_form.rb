class Panel::CreateMediaOwnerTrendingForm < Panel::BaseManualPostForm
  include ActiveModel::Model

  validates :owner_id, presence: true
  validate :image_xor_video

  private

  def image_xor_video
    unless image.blank? ^ video.blank?
      errors.add(:image, "Either image or video must be provided")
    end
  end

end
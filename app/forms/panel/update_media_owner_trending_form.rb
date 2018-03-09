class Panel::UpdateMediaOwnerTrendingForm < Panel::BaseManualPostForm

  validates :owner_id, presence: true
  validate :image_xor_video

  def initialize(media_owner_trending_attrs, form_attributes = {})
    super media_owner_trending_attrs.merge(form_attributes)
  end

  private

  def image_xor_video
    if !image.blank? && !video.blank?
      errors.add(:image, "Either image or video must be provided, not both")
    end
  end

  def image_attributes
    image || {}
  end

end

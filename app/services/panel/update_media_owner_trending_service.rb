class Panel::UpdateMediaOwnerTrendingService
  def initialize(media_owner_trending, form)
    @media_owner_trending = media_owner_trending
    @form = form
  end

  def call
    return false unless @form.valid?

    update_media_owner_trending
  end

  private

  def update_media_owner_trending
    attrs = @form.attributes
    unless @form.image.blank?
      attrs = attrs.merge({video: nil})
      @media_owner_trending.remove_video!
    end
    unless @form.video.blank?
      attrs = attrs.merge({image: nil})
      @media_owner_trending.remove_image!
    end

    @media_owner_trending.update_attributes(attrs)
    @media_owner_trending.save
    @media_owner_trending
  end

end

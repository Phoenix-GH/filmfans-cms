class Panel::UpdateMediaOwnerService
  def initialize(media_owner, form)
    @media_owner = media_owner
    @form = form
  end

  def call
    return false unless @form.valid?

    update_media_owner
  end

  private

  def update_media_owner
    @media_owner.update_attributes(@form.attributes)
    @media_owner.picture.update_attributes(@form.picture_attributes)
    @media_owner.background_image.update_attributes(@form.background_image_attributes)
  end
end

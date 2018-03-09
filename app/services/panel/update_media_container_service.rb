class Panel::UpdateMediaContainerService
  def initialize(media_container, form)
    @media_container = media_container
    @media_content = media_container.media_content
    @form = form
  end

  def call
    return false unless @form.valid?

    update_media_container
  end

  private

  def update_media_container
    @media_container.update_attributes(@form.media_container_attributes)
  end
end

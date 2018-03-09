class Panel::CreateMediaContainerService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_media_container
  end

  private

  def create_media_container
    MediaContainer.create(@form.media_container_attributes)
  end
end

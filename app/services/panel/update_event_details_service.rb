class Panel::UpdateEventDetailsService
  def initialize(event, form)
    @event = event
    @form = form
  end

  def call
    return false unless @form.valid?

    update_event
  end

  private
  def update_event
    @event.update_attributes(@form.attributes)
    @event.background_image.update_attributes(@form.background_image_attributes)
    @event.cover_image.update_attributes(@form.cover_image_attributes)
  end
end

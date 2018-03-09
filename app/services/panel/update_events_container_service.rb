class Panel::UpdateEventsContainerService
  def initialize(events_container, form)
    @events_container = events_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_events_container
    add_linked_events
  end

  def products_container
    @events_container
  end

  private

  def update_events_container
    @events_container.update_attributes(@form.events_container_attributes)
  end

  def add_linked_events
    Panel::CreateLinkedEventService.new(@events_container, @form.linked_events).call
  end

end

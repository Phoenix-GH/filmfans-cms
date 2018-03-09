class Panel::CreateEventsContainerService
  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_events_container
    add_linked_events
    add_admin_id
  end

  def events_container
    @events_container
  end

  private
  def create_events_container
    @events_container = EventsContainer.create(@form.events_container_attributes)
  end

  def add_linked_events
    Panel::CreateLinkedEventService.new(@events_container, @form.linked_events).call
  end

  def add_admin_id
    if @user.role == 'moderator'
      @events_container.update_attributes(admin_id: @user.id)
    end

    true
  end
end

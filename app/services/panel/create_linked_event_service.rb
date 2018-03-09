class Panel::CreateLinkedEventService
  def initialize(container, linked_events = [])
    @container = container
    @linked_events = linked_events
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_linked_events
      create_new_linked_events
    end
  end

  private
  def remove_old_linked_events
    @container.linked_events.delete_all
  end

  def create_new_linked_events
    @linked_events.each do |linked_event|
      position = linked_event[:position]
      event = Event.find_by(id: linked_event[:event_id])
      if event
        @container.linked_events.create(event: event, position: position)
      end
    end
  end
end

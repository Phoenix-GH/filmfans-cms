class EventsContainerSerializer
  def initialize(events_container)
    @events_container = events_container
  end

  def results
    return '' unless @events_container
    generate_events_container_json

    @events_container_json
  end

  private

  def generate_events_container_json
    @events_container_json = {
      type: 'events_container',
      id: @events_container.id,
      channel_id: @events_container&.channel&.id.to_i,
      name: @events_container.name.to_s,
      events: products_json
    }
  end

  def products_json
    @events_container.linked_events.order(:position).map do |linked_event|
      EventSerializer.new(
        linked_event.event,
        with_content: false
      ).results.merge(event_position: linked_event.position)
    end
  end
end

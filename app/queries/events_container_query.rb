class EventsContainerQuery < BaseQuery
  def results
    prepare_query
    admin_filter
    search_result
    order_results('created_at')

    @results
  end

  private

  def prepare_query
    @results = EventsContainer.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'events'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN linked_events ON linked_events.events_container_id = events_containers.id').
        group('events_containers.id').
        order("count(linked_events.id) #{direction}")
    else
      super(default_sort)
    end
  end

end

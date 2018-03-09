class EventQuery < BaseQuery
  def results
    prepare_query
    search_result
    admin_filter
    order_results('created_at')
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = Event.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'event_contents'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN event_contents ON event_contents.event_id = events.id').
        group('events.id').
        order("count(event_contents.id) #{direction}")
    else
      super(default_sort)
    end
  end
end

class MoviesContainerQuery < BaseQuery
  def results
    prepare_query
    admin_filter
    search_result
    order_results('created_at')

    @results
  end

  private

  def prepare_query
    @results = MoviesContainer.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'movies'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN linked_movies ON linked_movies.movies_container_id = movies_containers.id').
        group('movies_containers.id').
        order("count(linked_movies.id) #{direction}")
    else
      super(default_sort)
    end
  end

end
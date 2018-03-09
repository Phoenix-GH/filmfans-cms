class CollectionsContainerQuery < BaseQuery
  def results
    prepare_query
    admin_filter
    search_result
    order_results('created_at')
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = CollectionsContainer.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'collections'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN linked_collections ON linked_collections.collections_container_id = collections_containers.id').
        group('collections_containers.id').
        order("count(linked_collections.id) #{direction}")
    else
      super(default_sort)
    end
  end
end

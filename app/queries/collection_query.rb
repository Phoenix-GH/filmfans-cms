class CollectionQuery < BaseQuery
  def results
    prepare_query
    search_result
    channel_filter
    admin_filter
    order_results('created_at')
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = Collection.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'collection_contents'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN collection_contents ON collection_contents.collection_id = collections.id').
        group('collections.id').
        order("count(collection_contents.id) #{direction}")
    elsif filters[:sort] == 'products'
      direction = filters[:direction].presence || default_direction
      @results = @results.sort_by(&:products_count)
      @results.reverse! if direction == 'desc'
    else
      super(default_sort)
    end
  end
end

class ManualPostContainerQuery < BaseQuery
  def results
    prepare_query
    search_result
    order_results('created_at')

    @results
  end

  private

  def prepare_query
    @results = ManualPostContainer.all
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'posts'
      direction = filters[:direction].presence || default_direction
      @results = @results.
          joins('LEFT JOIN linked_manual_posts lot ON lot.manual_post_container_id = manual_post_containers.id').
          group('manual_posts_containers.id').
          order("count(lot.id) #{direction}")
    else
      super(default_sort)
    end
  end

end

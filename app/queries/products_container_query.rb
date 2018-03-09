class ProductsContainerQuery < BaseQuery
  def results
    prepare_query
    media_owner_filter
    channel_filter
    admin_filter
    ability_filter
    search_result('products_containers.name')
    order_results('created_at')
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = ProductsContainer.all
    unless filters[:category_id].blank?
      @results = @results.where(category_id: filters[:category_id])
    end
  end

  def media_owner_filter
    if filters[:media_owner_id].present?
      @results = @results.where(media_owner_id: filters[:media_owner_id])
    elsif filters[:with_media_owner]
      @results = @results.where.not(media_owner_id: nil)
    else
      @results = @results.where(media_owner_id: nil)
    end
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'media_owners.name'
      direction = filters[:direction].presence || default_direction
      @results = @results.joins(:media_owner)
      @results = @results.order("media_owners.name #{direction}")
    elsif filters[:sort] == 'products'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN linked_products ON linked_products.products_container_id = products_containers.id').
        group('products_containers.id').
        order("count(linked_products.id) #{direction}")
    else
      super(default_sort)
    end
  end
end

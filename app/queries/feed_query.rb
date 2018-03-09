class FeedQuery < BaseQuery
  def results
    prepare_query
    order_results
    paginate_result

    @results
  end

  private

  def prepare_query
    products_containers = ProductsContainerQuery.new(filters.merge(with_media_owner: true)).results
    media_containers = MediaContainerQuery.new(filters).results

    @results = products_containers + media_containers
  end

  def order_results
    @results = @results.sort_by(&:created_at).reverse
  end

  def paginate_result
    Kaminari.paginate_array(@results).page(filters[:page])
  end
end

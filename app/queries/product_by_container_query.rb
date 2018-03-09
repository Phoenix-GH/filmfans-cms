class ProductByContainerQuery < BaseQuery

  def results
    search_result
    paginate_result

    @results.size == 0 ? [] : @results
  end

  def count
    query.count
  end

  protected

  def search_result
    @results = query.order('position asc')
  end

  private

  def query
    Product.joins(:products_containers).where(products_containers: {category_id: [filters[:category_id]].flatten})
  end
end

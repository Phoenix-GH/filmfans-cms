class ThreedArQuery < BaseQuery
  def results
    prepare_query
    search_result
    order_results('created_at', 'desc')
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = ThreedAr.all
  end
end
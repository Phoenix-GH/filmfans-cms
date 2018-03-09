class ThreedModelQuery < BaseQuery
  def results
    prepare_query
    search_result('description')
    order_results('description', 'asc')
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = ThreedAr.find(filters[:threed_ar_id]).threed_models.all
  end

end


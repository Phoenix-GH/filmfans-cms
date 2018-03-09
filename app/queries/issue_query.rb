class IssueQuery < BaseQuery
  def results
    prepare_query
    order_results('publication_date')
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = Magazine.find(filters[:magazine_id]).issues.all
  end
end


class SocialAccountQuery < BaseQuery
  def results
    prepare_query
    search_result
    order_results
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = SocialAccount.all
  end
end

class SearchedPhraseQuery < BaseQuery
  def results
    prepare_query
    search_result('phrase')
    order_results('counter', 'desc')
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = SearchedPhrase.all
  end
end
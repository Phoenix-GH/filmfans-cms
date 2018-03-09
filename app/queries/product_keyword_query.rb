class ProductKeywordQuery < BaseQuery
  def results
    @keywords = normalize_keywords
    #return [] if @keywords.blank?

    prepare_query
    keywords_filter
    stores_filter
    search_result
    @results.size == 0 ? [] : @results
  end

  protected

  def prepare_query
    @query = {where: {}}
  end

  def keywords_filter
    unless @keywords.blank?
      @query[:where].merge!({ibm_keywords: @keywords})
    end
  end

  def stores_filter
    return if filters[:stores].blank?
    @query[:where].merge!({store: filters[:stores]})
  end

  def search_result
    @query[:page] = page
    @query[:per_page] = per
    @query[:order] = {id: 'desc'}
    @results = ProductKeyword.search @query

    # https://www.elastic.co/guide/en/elasticsearch/guide/current/phrase-matching.html
    # @results = ProductKeyword.search 'charcoal', fields: [:ibm_keywords],
    #                                  match: :phrase, page: page, per_page: per,
    #                                  misspellings: false
  end

  private
  def normalize_keywords
    return [] if filters[:keywords].blank?
    filters[:keywords].map { |k|
      ProductKeyword::normalize_keyword(k)
    }.compact
  end
end
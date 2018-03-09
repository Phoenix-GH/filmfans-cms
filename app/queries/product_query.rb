class ProductQuery < BaseQuery
  def results
    prepare_query
    brand_filter
    category_filter
    category_hierarchy_filter
    vendor_filter
    media_owner_filter
    channel_filter
    products_ids_filter
    exclude_product_ids_filter
    availability_filter
    order_filter
    search_result

    @results.size == 0 ? [] : @results
  end

  protected

  def prepare_query
    @query = {where: {}}
    @raw_query_filters = []
    @raw_query_order = {}
  end

  def brand_filter
    return if filters[:brand].blank?
    @query[:where].merge!( brand: filters[:brand] )
    @raw_query_filters << {"term" => {"brand" => "#{filters[:brand]}"}}
  end

  def category_filter
    if filters[:category_id].blank?
      @query[:where].merge!({product_categories: {not: [Category::QUARANTINE_CATEGORY_ID]}})
      @raw_query_filters << {"not" => {"filter" => {"in" => {"product_categories" => [Category::QUARANTINE_CATEGORY_ID]}}}}
    else
      @flatten_ids = [filters[:category_id]].flatten
      @query[:where].merge!({product_categories: @flatten_ids})
      @raw_query_filters << {"in" => {"product_categories" => @flatten_ids}}
    end
  end

  def category_hierarchy_filter
    return if filters[:category_hierarchy].blank?
    @query[:where].merge!({ category_hierarchy: { all: filters[:category_hierarchy] }})
    filters[:category_hierarchy].each { |category_hierarchy|
      @raw_query_filters << {"term" => {"category_hierarchy" => "#{category_hierarchy}"}}
    }
  end

  def media_owner_filter
    return if filters[:media_owner_id].blank?
    @query = {where: {id: []}}.deep_merge(@query)

    @product_ids = ProductMediaOwnerQuery.new(
        filters[:media_owner_id]
    ).results

    update_product_ids_filters(@product_ids)
  end

  def channel_filter
    return if filters[:channel_id].blank?
    @query = {where: {id: []}}.deep_merge(@query)

    @channel_product_ids = ProductChannelQuery.new(
        filters[:channel_id]
    ).results

    update_product_ids_filters(@channel_product_ids)
  end

  def vendor_filter
    return if filters[:vendor].blank?
    @query[:where].merge!({ vendor: filters[:vendor] })
    @raw_query_filters << {"term" => {"vendor" => "#{filters[:vendor]}"}}
  end

  def products_ids_filter
    return if filters[:product_ids].blank?
    @query[:where].merge!({id: filters[:product_ids].uniq.map(&:to_s)})
    @raw_query_filters << {"in" => {"id" => filters[:product_ids].uniq.map(&:to_s)}}
  end

  def exclude_product_ids_filter
    return if filters[:exclude_product_ids].blank?
    @query[:where].merge!({id: {not: filters[:exclude_product_ids].uniq.map(&:to_s)}})
    @raw_query_filters << {"not" => {"filter" => {"in" => {"id" => filters[:exclude_product_ids].uniq.map(&:to_s)}}}}
  end

  def availability_filter
    return if filters[:available].blank?
    @query[:where].merge!({available: filters[:available]})
    @raw_query_filters << {"term" => {"available" => "#{filters[:available]}"}}
  end

  def order_filter
    sort = filters[:sort].presence
    # when searching by name/brand, let elasticsearch order by relevance
    if name_keyword.blank? && brand_keyword.blank?
      sort = sort || 'created_at'
      direction = filters[:direction].presence || (sort == 'created_at' ? 'desc' : 'asc')
    elsif sort.present?
      direction = filters[:direction].presence || 'asc'
    end

    unless sort.blank? or direction.blank?
      @query[:order] = {sort => direction}
      @raw_query_order = {sort => direction}
    end
  end

  def name_keyword
    filters[:search]&.downcase
  end

  def brand_keyword
    filters[:brand_search]&.downcase
  end

  def search_result
    name = name_keyword
    brand = brand_keyword
    unless name.present? && brand.present?
      @query.merge!({page: page})
      @query.merge!({per_page: per})
    end

    # misspellings: {below: page_size}
    # means: only search with misspelling correction if the result is less than one page. The first page, search by
    # exact character sequence
    #
    # misspelling correction will create some unwanted effect like: search for 'rolex', will match 'asnolexis'

    if name.blank? && brand.blank?
      @results = Product.search '*', @query
    elsif name.present? && brand.present?
      name_match_clause = {
          "name_exact.text_middle" => {
              "query" => "#{name}",
              "boost" => 1,
              "operator" => "and",
              "analyzer" => "searchkick_autocomplete_search",
      }
      }
      brand_match_clause = {
          "brand_exact.text_middle" => {
              "query" => "#{brand}",
              "boost" => 1,
              "operator" => "and",
              "analyzer" => "searchkick_autocomplete_search",
      }
      }
      must_clause = [
          {
              "match" => name_match_clause
      },
          {
              "match" => brand_match_clause
      }
      ]

      @query = {
          "query" => {
              "filtered" => {
                  "query" => {
                      "bool" => {
                          "must" => must_clause
      }
      },
                  "filter" => @raw_query_filters
      }
      }
      }

      @query[:order] = @raw_query_order unless @raw_query_order.blank?
      @results = Product.search(@query).results

      if @results.length < per
        # Perform another query with misspelling
        name_match_clause[:"name_exact.text_middle"] = name_match_clause[:"name_exact.text_middle"].merge(
            {
                "fuzziness" => 1,
                "prefix_length" => 0,
                "max_expansions" => 20,
                "fuzzy_transpositions" => true
        }
        )
        brand_match_clause[:"brand_exact.text_middle"] = brand_match_clause[:"brand_exact.text_middle"].merge(
            {
                "fuzziness" => 1,
                "prefix_length" => 0,
                "max_expansions" => 20,
                "fuzzy_transpositions" => true
        }
        )
        dis_max_must_clause = {
            "dis_max" => {
                "queries" => [
            {
                "match" => name_match_clause
        },
            {
                "match" => brand_match_clause
        }
        ]
        }
        }
        @query[:query][:filtered][:query][:bool][:must] = dis_max_must_clause
        @results = Product.search(@query).results
      end
      paginate_result
    elsif name.present?
      @results = Product.search(name, @query.merge(fields: [:brand_exact, :name_exact], match: :text_middle, misspellings: {below: per}))
    else
      @results = Product.search(brand, @query.merge(fields: [:brand_exact], match: :text_middle, misspellings: {below: per}))
    end
  end

  def update_product_ids_filters(product_ids)
    filters[:product_ids] ||= []
    filters[:product_ids] = filters[:product_ids] + product_ids
  end
end

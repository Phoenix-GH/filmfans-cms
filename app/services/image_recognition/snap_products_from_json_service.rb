class ImageRecognition::SnapProductsFromJsonService
  attr_reader :man_products, :woman_products, :message, :classifier, :classifier_probability, :result_pids, :prs_result_pids, :json, :keywords

  def initialize(response, user_id)
    response ||= "{}"

    if response.instance_of? String
      @json = ActiveSupport::JSON.decode(response)
    else
      @json = response
    end
    @user_id = user_id
  end

  def call
    set_message

    @result_pids = []
    @prs_result_pids = []
    @classifier = @json['classification_results']
    @classifier_probability = @json['probability']

    @total_prs_found_prods = 0

    @man_products = find_products_in_db('man')
    @woman_products = find_products_in_db('woman')
    if (@man_products.size + @woman_products.size) == 0
      @man_products = search_products_by_keywords
    end

    total_found_in_hs = @man_products.size + @woman_products.size

    if total_found_in_hs != @total_prs_found_prods
      Rails.logger.info "Total products return by PRS #{@total_prs_found_prods}, total found in HS #{total_found_in_hs}"
    else
      Rails.logger.info "Total products return by PRS #{@total_prs_found_prods}"
    end

    filter_out_sold_out_products

    create_snapped_products
    true

  rescue Exception => e
    LogHelper.log_exception(e)
    false
  end

  def self.number_of_prs_result_products
    n = ImageRecognition::SnapProductsFromJsonService.number_of_apps_result_products * 10
    n > 200 ? 200 : n
  end

  private

  def filter_out_sold_out_products
    @man_products = sort_by_availability(@man_products, ImageRecognition::SnapProductsFromJsonService.number_of_apps_result_products)
    @woman_products = sort_by_availability(@woman_products, ImageRecognition::SnapProductsFromJsonService.number_of_apps_result_products)

    @result_pids = @man_products.map { |p| p.id }
    @result_pids += @woman_products.map { |p| p.id }

    Rails.logger.info "PRS returned #{@total_prs_found_prods} products, #{@result_pids.size} products returned to the apps"
  end

  def sort_by_availability(products, number_of_items)
    return [] if products.nil?
    products_with_ordinal = products.each_with_index.map { |p, index| {ordinal: index, product: p} }
    # available products on top of the list, then, original ordinal
    top_avails = products_with_ordinal.sort_by { |pwi| [pwi[:product].available ? -1 : 1, pwi[:ordinal]] }
                     .first(number_of_items)
    # come back to sort by relevant (image matching)
    top_avails.sort_by { |pwi| [pwi[:ordinal]] }
        .map { |pwi| pwi[:product] }
  end

  def search_products_by_keywords
    return [] if @json['keywords'].blank?

    @keywords = @json['keywords']
    Rails.logger.info "Searching products by keywords: #{@keywords}"
    query = ProductKeywordQuery.new(
        {
            per: ImageRecognition::SnapProductsFromJsonService.number_of_prs_result_products,
            keywords: @keywords
        })
    pids = query.results.map { |pk| pk.product_id }

    find_products_in_db_by_pids(pids)
  end

  def self.number_of_apps_result_products
    ENV['PRS_NUMBER_OF_RETURN_PRODUCTS']&.to_i || 12
  end

  def set_message
    @message = @json['message']
  end

  def find_products_in_db(key)
    return [] unless @json['result'] && @json['result'][key]

    prs_pids = @json['result'][key].map { |json| json['pid'].to_i }

    find_products_in_db_by_pids(prs_pids)
  end

  def find_products_in_db_by_pids(prs_pids)
    @prs_result_pids += prs_pids
    @total_prs_found_prods += prs_pids.size

    pids_set = prs_pids.uniq
    # sort by ids
    unsorted_products = Product.where(id: pids_set).to_a
    products = pids_set
                   .inject([]) { |result, pid| result << unsorted_products.detect { |p| p.id == pid } }
                   .compact # remove nil items

    # log problematic result
    if prs_pids.size != pids_set.size
      Rails.logger.info "PRS returns #{prs_pids.size - pids_set.size} duplicated PIDs"
    end

    db_pids = Set.new(products.map { |p| p.id })
    nonexistent_pids = pids_set.reject { |id| db_pids.include?(id) }
    unless nonexistent_pids.blank?
      Rails.logger.error "PIDs [#{nonexistent_pids}] were returned by PRS but not found in HS DB"
    end

    products
  end

  def create_snapped_products
    return unless @user_id && (user = User.find_by(id: @user_id))

    SaveSnappedProductsWorker.perform_async(user.id, @result_pids)
  end
end

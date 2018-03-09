class Api::V1::ProductsController < Api::V1::BaseController
  def index

    results = []

    landing_product_count = 0

    if products_search_params[:category_id].present?
      landing_query = ProductByContainerQuery.new(products_search_params)
      landing_product_count = landing_query.count

      # exceed the number of landing product?
      unless landing_product_count < ((landing_query.page - 1) * landing_query.per)
        results = landing_query.results
      end
    end

    results += search_additional_products(results, landing_product_count)

    json = results.map { |res|
      ProductSerializer.new(
          res,
          with_similar_products: false
      ).results
    }

    json = ProductSerializer.reorder_products_by_country(json, params[:current_country])

    render json: json
  end

  def index_shortened
    results = new_product_query.results

    render json: results, only: [:id, :name]
  end

  def show
    product = Product.find(params[:id])

    if params[:log_price] == 'true'
      product.variants.each do |v|
        v.variant_stores.each do |s|
          Rails.logger.info "PID: #{params[:id]} price: #{s.price} sale: #{s.sale_price} currency: #{s.currency} min-price: #{product.minimal_price} rate: #{CurrencyService::get_exchange_rate(s.currency, CurrencyService::APP_CURRENCY)}"
        end
      end
    end

    render json: ProductSerializer.new(
      product,
      with_variants: true,
      with_similar_products: true
    ).results
  end

  def learning
    begin
      results = new_product_query.results.records.includes(:categories, variants: :variant_stores)
      render json: results.map { |res| ProductLearningSerializer.new(res).results }
    rescue Exception => e
      logger.info "Searchkick (product/learning) error for #{products_search_params}: #{e.message}"
      render json: {}.to_json
    end
  end

  def learning_count
    begin
      total_count = new_product_query.results.total_count
    rescue Exception => e
      logger.info "Searchkick (product/learning_count) error for #{products_search_params}: #{e.message}"
      total_count = 0
    end
    render json: { total_count: total_count}.to_json
  end

  def keyword_search
    query = ProductKeywordQuery.new(keyword_search_params)
    result = query.results.map { |pk| {pid: pk.product_id, im_url: pk.image_url} }
    render json: result
  end

  private

  def new_product_query
    ProductQuery.new(products_search_params)
  end

  def products_search_params
    return @products_search_params unless @products_search_params.blank?

    @products_search_params = params.permit(
        :search,
        :brand_search,
        :page,
        :per,
        :vendor,
        :available,
        category_hierarchy: [],
        product_ids: [],
        channel_id: [],
        category_id: [],
        media_owner_id: []
    )

    cat_ids = @products_search_params[:category_id]
    unless cat_ids.blank?
      cat_ids = cat_ids.map { |ci| Category.find_by(id: ci) }
                    .select { |c| !c.blank? }
                    .map { |c| Category::all_leaf_children(c) }
                    .flatten
                    .map { |c| c.id }
      @products_search_params[:category_id] = cat_ids
    end

    @products_search_params
  end

  def keyword_search_params
    params.permit(
        :page,
        :per,
        apps: [],
        stores: [],
        keywords: [],
    )
  end

  def search_additional_products(landing_result, total_landing_product_count)
    query = new_product_query
    page = query.page
    per = query.per

    return [] unless landing_result.size < per

    # how many whole page the landing products take
    # ex: per = 10
    #   total = 20 ==> 2 page
    #   total = 11 ==> 1 page
    #   total = 9  ==> 0 page
    landing_page = (total_landing_product_count / per.to_f).floor # always round down e.g. 2.1 -> 2

    # the new page after all landing products
    new_page = page - landing_page
    new_per = per - landing_result.size

    if new_per <= 0 || new_page <= 0
      logger.error "Unexpected page/per calculated. page #{page}, per #{per}; landing-count #{total_landing_product_count}" \
                  " current landing result #{landing_result.size}; new page #{new_page} new per #{new_per}"
      return []
    end

    do_product_search(new_page, new_per, landing_result)
  end

  def do_product_search(new_page, new_per, landing_result)
    if products_search_params[:search].present?
      form = Api::V1::CreateSearchedPhraseForm.new(
          products_search_params[:search],
          products_search_params[:language]
      )
      Api::V1::CreateSearchedPhraseService.new(form).call
    end

    search_params = products_search_params

    search_params[:page] = new_page
    search_params[:per] = new_per
    search_params[:exclude_product_ids] = landing_result.map { |p| p.id }
    search_params[:available] = true

    ProductQuery.new(search_params).results
  end

end

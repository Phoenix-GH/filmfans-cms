class Product < ActiveRecord::Base
  searchkick word_start: [:name, :brand], text_middle: [:name_exact, :brand_exact] #, index_name: "products_production"

  has_many :tags, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :product_similarity, foreign_key: :product_from_id, dependent: :destroy
  has_many :similar_products, through: :product_similarity, source: :product_to
  #has_many :product_files, dependent: :destroy
  has_many :product_files_list, foreign_key: 'product_id', class_name: 'ProductFileList'
  has_many :variants, dependent: :destroy
  has_many :product_option_types, dependent: :destroy
  has_many :option_types, through: :product_option_types
  has_many :snapped_products, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :issue_tag_products, dependent: :destroy
  has_one :product_keyword, dependent: :destroy

  # for querying
  has_many :linked_products, dependent: :destroy
  has_many :products_containers, through: :linked_products

  serialize :category_hierarchy, Array
  serialize :product_files, ProductFilesJsonSerializer

  scope :search_import, -> { includes(:product_categories) }

  after_save :cache_brands!
  after_destroy :cache_brands!

  def self.cache_brands!
    brands = Product.search("*", aggs: [:brand]).aggs['brand']['buckets'].map { |x| x['key'] }.uniq.sort_by { |b| b.downcase }
    Rails.cache.write('brands', brands, time_to_idle: 1.seconds, timeToLive: 90.seconds)
    brands
  end

  def self.brands_for_select
    brands = Rails.cache.read('brands')
    brands.blank? ? self.cache_brands! : brands
  end

  def self.fix_buggy_image_url(url_str)
    return nil if Product::url_blank?(url_str)

    # for YOOX
    # if url_str.start_with?('http://LARGE-IMAGE>>')
    #   fixed_url = url_str.sub('http://LARGE-IMAGE>>', '')
    #   if Product::url_blank?(fixed_url)
    #     return nil
    #   else
    #     return fixed_url
    #   end
    # end
    #
    # # vestiaire URL
    # if url_str.end_with?('?auto=format&w=200')
    #   return url_str.gsub(/\?auto=format&w=200$/, '')
    # end

    url_str
  end

  def get_normalized_name
    name
        &.gsub("\\\"", "\"")
        &.gsub(/(<b>|<\/b>)/, '')
        &.gsub(/(<br>)/, " \n")
  end

  def get_normalized_brand
    brand
        &.gsub("\\\"", "\"")
        &.gsub(/(<b>|<\/b>)/, '')
        &.gsub(/(<br>)/, " \n")
  end

  def get_normalized_description
    description
        &.gsub("\\\"", "\"")
        &.gsub(/(<b>|<\/b>)/, '')
        &.gsub(/(<br>)/, " \n")
  end

  def image_display_url
    image_object = primary_image_object
    return if image_object.blank?

    if !image_object.thumb_cover_image_url.blank?
      Product::fix_buggy_image_url(image_object.thumb_cover_image_url)
    elsif !image_object.small_cover_image_url.blank?
      Product::fix_buggy_image_url(image_object.small_cover_image_url)
    elsif !image_object.large_cover_image_url.blank?
      Product::fix_buggy_image_url(image_object.large_cover_image_url)
    end
  end

  def primary_image_object
    self.product_files&.each do |file|
      return file unless all_url_blank? file
    end

    self.product_files_list&.each do |file|
      return file unless all_url_blank? file
    end

    self.variants&.each do |variant|
      variant.variant_files&.each do |file|
        return file unless all_url_blank? file
      end
    end

    self.variants&.each do |variant|
      variant.variant_files_list&.each do |file|
        return file unless all_url_blank? file
      end
    end
    nil
  end

  def cover_image
    product_files.first&.cover_image
  end

  def cover_image_url
    primary_image_object&.small_cover_image_url
  end

  def primary_category
    categories.first
  end

  def name_exact
    self.name
  end

  def brand_exact
    self.brand
  end

  def minimal_price
    result = get_variants_prices.min
    return result unless result.nil?

    CurrencyService::get_first_price_in_app_currency(price_range)
  end

  def maximal_price
    result = get_variants_prices.max
    return result unless result.nil?

    CurrencyService::get_last_price_in_app_currency(price_range)
  end

  def get_variants_prices
    # explanation:
    # - if @variant_prices has not been built yet, build it. Hence, only built once/request
    # - get all variants plus their stores in one go (hence avoid 1-N loading)
    # - flatten all stores in all variants into an array
    # - for each store, return the price converted to app's currency if needed
    # - remove all null prices
    @variant_prices ||= self.variants.includes(:variant_stores).map(&:variant_stores).
        flatten.map { |store|
      [CurrencyService::convert_to_app_currency(store.price, store.currency),
       CurrencyService::convert_to_app_currency(store.sale_price, store.currency)] }.flatten.reject(&:nil?)
  end

  def currency
    CurrencyService::APP_CURRENCY
  end

  def search_data
    {
        id: id,
        name: name&.downcase,
        name_exact: name_exact,
        product_categories: product_categories.pluck(:category_id),
        brand: brand&.downcase,
        brand_exact: brand_exact,
        vendor: vendor,
        created_at: created_at,
        updated_at: updated_at,
        available: available
    }
  end

  def vendor
    self.class.joins(variants: {variant_stores: :store}).
        select('stores.name as store_name').
        where(products: {id: self.id}).
        first&.
        store_name
  end

  def manually_added?
    vendor == 'Manually added products'
  end

  def price
    amount = minimal_price
    return nil if amount.nil?

    money = Money.from_amount(amount, CurrencyService::APP_CURRENCY)
    CurrencyService::APP_CURRENCY + money.format(:with_currency => false, :symbol => false)
  end

  def categories_array
    [].tap do |arr|
      categories.each do |category|
        arr << category.full_name
      end
    end
  end

  def name_with_brand
    brand.present? ? brand + ' ' + name : name
  end

  def size_guides
    # keep the creation order. Future, a position column may be added to control the order of sizes
    @size_guides ||= SizeGuide.joins(category: [:product_categories]).where(product_categories: {product_id: self.id}).order(:id)
  end

  def get_similarity
    Product.where(:id => product_similarity.select(:product_to_id).map(&:product_to_id))
  end

  private
  def cache_brands!
    Product.cache_brands!
  end

  def all_url_blank? file
    Product::url_blank?(file&.large_cover_image_url) &&
        Product::url_blank?(file&.small_cover_image_url) &&
        Product::url_blank?(file&.thumb_cover_image_url)
  end

  def self.url_blank?(url)
    url.nil? || url.empty? || url.casecmp('None') == 0
  end
end

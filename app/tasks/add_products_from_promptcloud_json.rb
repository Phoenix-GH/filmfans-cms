require 'logger'
class AddProductsFromPromptcloudJson
  def initialize(json)
    @products = json['root']['page']
    @size = OptionType.find_or_create_by(name: 'size')
    @color = OptionType.find_or_create_by(name: 'color')
  end

  def call
    @products.each do |product|
      # begin
        @record = product['record']
        next if invalid_record?

        create_product
        create_variants
        create_similar_products
      # rescue Exception => e
      #   log.error "Error in division!: #{e}"
      #   next
      # end
    end
  end

  private
  def invalid_record?
    if category_json[@record['category_hierarchy'].to_s].nil?
      wrong_category_log.error "#{@record['asin']}: #{@record['detail_pageurl']}"
      true
    elsif @record['item_base_price'].nil?
      without_price_log.error "#{@record['asin']}: #{@record['detail_pageurl']}"
      true
    end
  end

  def create_product
    @new_product = Product.where(product_code: @record['uniq_id']).first_or_initialize
    @new_product.name = @record['product_name']
    @new_product.category_ids = category_json[@record['category_hierarchy'].to_s]
    @new_product.category_hierarchy = @record['category_hierarchy']
    @new_product.price_range = @record['item_base_price']

    if @new_product.product_files.any? && !JSON.parse(@new_product.product_files.first.to_json).blank? #second import prevent duplication
      @new_product.save!
      return
    else
      CreateMediaContentFromJson.new(@record['images']['default_image_links'], @new_product).call
      @new_product.save!
    end
  end

  def create_variants
    return if @new_product.variants.count > 1 # some products was imported with wariants

    @sizes = []
    if @record['available_sizes'] && @record['available_colors']
      clear_variants
      find_or_create_sizes(@record['available_sizes'], @size)
      find_or_create_colors(@color)
    elsif @record['available_sizes']
      clear_variants
      find_or_create_sizes(@record['available_sizes'], @size, true)
    elsif @record['available_colors']
      clear_variants
      find_or_create_colors(@color)
    else
      return if @new_product.variants.any?
      variant = Variant.create(product: @new_product)
      create_variant_store(variant)
    end
  end

  def find_or_create_sizes(record, type, with_variants = false)
    ProductOptionType.create(product: @new_product, option_type: type)

    record.each do |size|
      option_value = OptionValue.find_or_create_by(
        option_type: type,
        name: size.last
      )
      @sizes << option_value

      if with_variants
        variant = Variant.create(product: @new_product)
        OptionValueVariant.create(variant: variant, option_value: option_value)
        create_variant_store(variant)
      end
    end
  end

  def clear_variants
    @new_product.variants.destroy_all
  end

  def find_or_create_colors(type)
    ProductOptionType.create(product: @new_product, option_type: type)

    @record['available_colors'].each do |color|
      option_value = OptionValue.find_or_create_by(
        option_type: type,
        name: color.last
      )

      if @sizes.present?
        @sizes.each do |size|
          variant = Variant.create(product: @new_product)
          OptionValueVariant.create(variant: variant, option_value: option_value)
          OptionValueVariant.create(variant: variant, option_value: size)
          create_variant_store(variant)

          add_image_variants(variant, color.first)
        end
      else
        variant = Variant.create(product: @new_product)
        OptionValueVariant.create(variant: variant, option_value: option_value)
        create_variant_store(variant)
        add_image_variants(variant, color.first)
      end
    end
  end

  def add_image_variants(variant, color)
    images = @record['images']['color_image_variants']["#{color}"]
    CreateMediaContentFromJson.new(images, variant).call
  end

  def create_variant_store(variant)
    store = VariantStore.new
    store.variant = variant
    store.url = @record['detail_pageurl']
    store.price = product_price
    store.currency = product_currency
    store.sku = @record['asin']
    store.store_id = amazon_store_id
    store.save
  end

  def create_similar_products
    return unless @record['similar_products']
    return if @new_product.product_similarity.any? #second import prevent duplication
    [@record['similar_products']].flatten.each do |product|
      if variant_store = VariantStore.find_by(sku: product['asin'])
        ProductSimilarity.create(product_from: @new_product, product_to_id: variant_store.variant.product_id)
        ProductSimilarity.create(product_to_id: variant_store.variant.product_id, product_from: @new_product)
      end
    end
  end

  def product_price
    unless Monetize.parse_collection(@record['item_base_price']).range?
      price =  Monetize.parse_collection(@record['item_base_price']).first
      Monetize.parse(price).fractional * 0.01
    end
  end

  def product_currency
    price =  Monetize.parse_collection(@record['item_base_price']).first
    Monetize.parse(price).currency.iso_code
  end

  def more_than_one(images)
    images['default_image_links'].is_a? Array
  end

  def without_price_log
    @without_price_log ||= Logger.new('log/without_price.log')
  end

  def wrong_category_log
    @wrong_category_log ||= Logger.new('log/wrong_category.log')
  end

  def log
    @log ||= Logger.new('log/log_file.log')
  end

  def category_json
    category_file = File.read('promptcloud_categories.json')
    ActiveSupport::JSON.decode(category_file)
  end

  def amazon_store_id
    @amazon_store_id ||= Store.find_or_create_by(name: 'Amazon').id
  end
end

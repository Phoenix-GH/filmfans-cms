class ProductSerializer
  def initialize(product, with_variants: false, with_similar_products: false)
    @product = product
    @with_similar_products = with_similar_products
    @with_variants = with_variants
  end

  def results
    return '' unless @product
    generate_product_json
    add_similar_products
    add_variants
    add_countries

    @product_json
  end

  def self.reorder_products_by_country(product_json_list, country_code)
    return product_json_list unless country_code
    return product_json_list unless product_json_list
    # move to the head of the list products that have one of theirs countries equal to the given country code

    products_matched_country = []
    products_unmatched_country = []

    product_json_list.each { |product|
      if product[:countries]&.include?(country_code)
        products_matched_country << product
      else
        products_unmatched_country << product
      end
    }
    products_matched_country + products_unmatched_country
  end

  private
  def generate_product_json
    @product_json = {
        id: @product.id,
        name: @product.name&.gsub("\\\"", "\""),
        brand: @product.brand&.gsub("\\\"", "\""),
        category: @product.categories_array,
        description: @product.get_normalized_description,
        vendor_url: @product.vendor_url.to_s,
        vendor: @product.vendor&.gsub("\\\"", "\""),
        image: Product::fix_buggy_image_url(@product.primary_image_object&.large_cover_image_url.to_s),
        small_image: Product::fix_buggy_image_url(@product.primary_image_object&.small_cover_image_url.to_s),
        medium_image: Product::fix_buggy_image_url(@product.primary_image_object&.thumb_cover_image_url.to_s),
        price_min: @product.minimal_price,
        price_max: @product.maximal_price,
        currency: @product.currency,
        asin: @product.variants.first&.sku.to_s,
        available: product_availablity
    }

    # workaround for the app
    # big to small
    fallback_attribute(:image, :medium_image, :small_image)
    fallback_attribute(:medium_image, :small_image)
    # small to big
    fallback_attribute(:small_image, :medium_image, :image)
    fallback_attribute(:medium_image, :image)
  end

  def fallback_attribute(check, back, back_next=nil)
    if @product_json[check].blank?
      if @product_json[back].blank? && !back_next.blank?
        @product_json[back] = @product_json[back_next]
      end
      @product_json[check] = @product_json[back]
    end
  end

  def add_similar_products
    return unless @with_similar_products

    similar_products = @product.similar_products.map do |product|
      ProductSerializer.new(
        product,
        with_similar_products: false
      ).results
    end

    @product_json.merge!(similar_products: similar_products)
  end

  def add_variants
    return unless @with_variants

    variants = @product.variants&.map do |variant|
      VariantSerializer.new(variant).results
    end

    variants = variants.map { |variant| split_multiple_variants_with_size_and_color(variant) }.flatten

    fake_id = 0
    variants.each do |var|
      fake_id -= 1
      var[:id] = fake_id
    end

    @product_json.merge!(variants: variants)
  end

  def split_multiple_variants_with_size_and_color(variant)
    return [variant] if variant[:option_values].blank?
    sizes = []
    colors = []
    variant[:option_values].each do |option_value|
      if option_value[:option_type] == 'size'
        sizes << option_value[:value]
      end
      if option_value[:option_type] == 'color'
        colors << option_value[:value]
      end
    end

    return [variant] if sizes.blank? && colors.blank?

    # void it first
    variant[:option_values] = []

    variants_results = []
    if sizes.blank?
      colors.map do |color|
        new_var = variant.deep_dup
        variants_results << new_var

        new_var[:option_values] << {
            option_type: 'color',
            value: color
        }
      end
    elsif colors.blank?
      sizes.map do |size|
        new_var = variant.deep_dup
        variants_results << new_var

        new_var[:option_values] << {
            option_type: 'size',
            value: size
        }
      end
    else
      colors.each do |color|
        sizes.each do |size|
          new_var = variant.deep_dup
          variants_results << new_var
          new_var[:option_values] << {
              option_type: 'color',
              value: color
          }
          new_var[:option_values] << {
              option_type: 'size',
              value: size
          }
        end
      end
    end
    variants_results
  end

  def add_countries
    country_set = Set.new

    @product.variants&.each { |variant|
      variant&.variant_stores&.each { |variant_store|
        country_set.merge(variant_store&.store&.country || [])
      }
    }
    @product_json.merge!(countries: country_set)
  end

  def product_availablity
    @product.minimal_price.present? ? 1 : 0
  end

  def add_variant_stores(variants_json)
    variant_stores = @product.variants&.first&.variant_stores&.map do |variant_store|
      VariantStoreSerializer.new(variant_store).results
    end

    variant_stores = variant_stores || []

    variants_json.each do |variant|
      variant[:variant_stores] = variant_stores
    end
  end

end

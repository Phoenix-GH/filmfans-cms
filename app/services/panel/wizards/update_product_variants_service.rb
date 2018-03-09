class Panel::Wizards::UpdateProductVariantsService

  def initialize(product, form)
    @product = product
    @form = form
    @prices = []
  end

  def call
    return false unless @form.valid? || @product.blank? || !@product.persisted?
    ActiveRecord::Base.transaction do
      remove_old_variants
      create_variants
      set_price_min_max
    end
  end

  private

  def remove_old_variants
    @product.variants.destroy_all
  end

  def create_variants
    @form.variants.each do |variant_data|
      variant_data.sizes.each do |size_and_price|
        ActiveRecord::Base.transaction {
          create_variant(variant_data, size_and_price)
        }
      end
    end
  end

  def set_price_min_max
    @product.update(price_range: "$#{@prices.min} - $#{@prices.max}")
  end

  def create_variant(variant_data, size_and_price)
    variant = Variant.create({
      product_id: @product.id,
      position: variant_data.position,
      description: variant_data.description,
    })

    variant_files = build_variant_files_from_temp_image(variant, variant_data.temp_image_ids)
    variant.variant_files = variant_files
    variant.save

    create_option_value_variants(variant, 'color', variant_data.color)
    create_option_value_variants(variant, 'size', size_and_price.size)

    create_variant_store(variant, size_and_price.price, size_and_price.currency)
  end

  def create_variant_store(variant, price, currency='USD')
    manual_store = Store.find_by(name: 'Manually added products')
    @prices << price.to_f
    VariantStore.create!(
      store_id: manual_store.id,
      variant_id: variant.id,
      price: price.to_f,
      currency: currency,
      # sku:
      # quantity:
      # url:
    )
  end

  def build_variant_files_from_temp_image(variant, temp_image_ids=[])
    vfs = []
    temp_image_ids.each do |_id|
      temp_image = TempImage.find(_id)

      args = if Rails.env.production?
        {
          remote_file_url: temp_image.image.url,
          remote_cover_image_url: temp_image.image.url,
        }
             elsif Rails.env.development? || Rails.env.test?
        {
          file: temp_image.image,
          cover_image: temp_image.image,
        }
             end

      vf = VariantFile.new(
        args.merge(variant_id: variant.id)
      )
      vf.save!
      vfs << vf
    end
    vfs
  end

  def create_option_value_variants(variant, option_type_name, option_value_name)
    return if option_value_name.blank?
    ot = OptionType.find_or_create_by(name: option_type_name)
    ov = ot.option_values.find_or_create_by(name: option_value_name) if ot&.persisted?
    if ov&.persisted?
      OptionValueVariant.create!(option_value_id: ov.id, variant_id: variant.id)
    end
  end


end

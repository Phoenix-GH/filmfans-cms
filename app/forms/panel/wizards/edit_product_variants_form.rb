class Panel::Wizards::EditProductVariantsForm
  include ActiveModel::Model

  attr_accessor(
      :variants, :id
  )

  def initialize(product)
    variants_attributes = parse_attributes(product)
    super defaults.merge(variants_attributes)
  end

  def parse_attributes(product)
    variants_attributes = {}
    product.variants.group_by(&:color).each_with_index do |(color, variants), idx|
      first_variant = variants.first
      sizes_attributes = {}
      variants.map.with_index do |variant, size_idx|
        sizes_attributes[size_idx] = {size: variant.size, price: variant.price}
      end

      temp_image_ids = create_tmp_images(first_variant).map(&:id)

      variants_attributes[idx] = {
          color: first_variant.color,
          description: first_variant.description,
          position: first_variant.position,
          sizes_attributes: sizes_attributes,
          temp_image_ids: temp_image_ids
      }
    end
    {variants_attributes: variants_attributes}
  end

  def create_tmp_images(variant)
    tmp_images = []
    variant.variant_files.each do |variant_file|
      args = if Rails.env.production?
               {
                   remote_image_url: variant_file.cover_image.url
               }
             elsif Rails.env.development? || Rails.env.test?
               {
                   image: variant_file.cover_image
               }
             end

      tmp_image = TempImage.new(
          args
      )
      tmp_image.save!
      tmp_images << tmp_image
    end
    tmp_images
  end

  def variants_attributes=(attributes)
    @variants = set_variants(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :variants, Panel::Wizards::UpdateVariantForm

  private
  def set_variants(attributes)
    attributes.map do |i, params|
      Panel::Wizards::UpdateVariantForm.new(params.except(:_destroy)) unless params[:_destroy] == 'true'
    end.compact
  end

  def defaults
    { variants: [] }
  end

end

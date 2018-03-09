class Panel::CreateProductsContainerForm
  include ActiveModel::Model

  attr_reader :media_content
  attr_accessor(
      :name, :description, :product_ids, :media_owner_id, :media_content_id, :channel_id, :linked_products, :category_id, :translation
  )

  validates :name, presence: true
  validates :media_content_id, media_content_presence: true, if: :media_owner?
  validate :at_least_one_linked_product

  include Translation
  translate :name

  def initialize(attributes = {})
    super(defaults.merge(attributes))
    @media_content = MediaContent.find(media_content_id) if media_content_id.present?
  end

  def products_container_attributes
    {
        name: name,
        description: description,
        media_owner_id: media_owner_id,
        media_content: @media_content,
        channel_id: channel_id
    }
  end

  def products_linked
    product_ids ? product_ids.split(",") : []
  end

  def linked_products_attributes=(attributes)
    @linked_products = set_linked_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :linked_products, LinkedProduct

  private
  def media_owner?
    media_owner_id.present?
  end

  def defaults
    { linked_products: [] }
  end

  def set_linked_products(attributes)
    attributes.map do |i, params|
      LinkedProduct.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def at_least_one_linked_product
    if linked_products.blank?
      errors[:linked_products] << '- at least one must be present'
    end
  end
end

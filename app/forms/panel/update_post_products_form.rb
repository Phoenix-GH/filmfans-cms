class Panel::UpdatePostProductsForm
  include ActiveModel::Model

  attr_accessor(
    :post_products,
    :id
  )

  def initialize(attributes = {}, form_params = {})
    if attributes.blank?
      super(defaults.merge(form_params))
    else
      super(attributes.merge(form_params))
    end
  end

  def post_products_attributes=(attributes)
    @post_products = set_post_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :post_products, PostProduct

  def set_post_products(attributes)
    attributes.map do |i, params|
      PostProduct.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def defaults
    {post_products: []}
  end
end

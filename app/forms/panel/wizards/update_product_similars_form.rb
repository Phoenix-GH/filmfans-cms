class Panel::Wizards::UpdateProductSimilarsForm
  include ActiveModel::Model

  attr_accessor(
      :similar_products,
      :step,
      :id
  )

  def initialize(attributes = {}, form_params = {})
    if attributes.blank?
      super(defaults.merge(form_params))
    else
      super(attributes.merge(form_params))
    end
  end

  def similar_products_attributes=(attributes)
    @similar_products = set_similar_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :similar_products, ProductSimilarity

  def set_similar_products(attributes)
    attributes.map do |i, params|
      ProductSimilarity.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def defaults
    {similar_products: []}
  end
end

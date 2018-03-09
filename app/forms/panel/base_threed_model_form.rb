class Panel::BaseThreedModelForm
  include ActiveModel::Model

  def initialize(attributes = {}, form_params = {})
    if attributes.blank?
      super(defaults.merge(form_params))
    else
      super(attributes.merge(form_params))
    end
  end

  attr_accessor(
      :description, :file, :threed_ar_id, :threed_model_products, :id
  )

  validates :description, presence: true

  def attributes
    {
        description: description,
        file: file,
        threed_ar_id: threed_ar_id
    }
  end

  def threed_model_products_attributes=(attributes)
    @threed_model_products = set_threed_model_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :threed_model_products, ThreedModelProduct

  def set_threed_model_products(attributes)
    attributes.map do |i, params|
      ThreedModelProduct.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def defaults
    {threed_model_products: []}
  end
end
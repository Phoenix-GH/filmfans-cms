class Panel::ManualTrainingProductForm
  include ActiveModel::Model

  attr_accessor(
      :manual_training_products,
      :id
  )

  def initialize(attributes = {}, form_params = {})
    if attributes.blank?
      super(defaults.merge(form_params))
    else
      super(attributes.merge(form_params))
    end
  end

  def manual_training_products_attributes=(attributes)
    @manual_training_products = set_manual_training_products(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :manual_training_products, ManualTrainingProduct

  def set_manual_training_products(attributes)
    attributes.map do |i, params|
      ManualPostProduct.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def defaults
    {manual_training_products: []}
  end
end
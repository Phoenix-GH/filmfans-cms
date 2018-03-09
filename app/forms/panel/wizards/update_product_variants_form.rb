class Panel::Wizards::UpdateProductVariantsForm
  include ActiveModel::Model

  attr_accessor(
      :variants, :id
  )

  validate :at_least_one_variant

  def initialize(variants_attributes, form_attributes = {})
    super defaults.merge(form_attributes)
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

  def valid?
    self_valid = super
    variants.map(&:valid?).all? && self_valid
  end

  def errors
    super.tap do |errors|
      variants.map{|v| v.errors}.map{|e| e.messages}.each do |variant_messages|
        errors.messages.merge! variant_messages
      end
    end
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

  def at_least_one_variant
    if variants.blank?
      errors[:variants] << '- at least one must be present'
    end
  end
end

class Panel::Wizards::UpdateVariantForm
  include ActiveModel::Model

  attr_accessor(
      :description, :color, :sizes, :id, :_destroy, :position, :temp_image_ids
  )

  #validates_presence_of :color
  validate :at_lest_one_image
  #validate :at_lest_one_size

  def initialize(variants_attributes={}, form_attributes = {})
    super defaults.merge(variants_attributes.merge(form_attributes))
  end

  def temp_image_ids=(attributes)
    @temp_image_ids = attributes.split(',')
  end

  def sizes_attributes=(attributes)
    @sizes = set_sizes(attributes)
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
    sizes.map(&:valid?).all? && self_valid
  end

  def errors
    super.tap do |errors|
      sizes.map{|v| v.errors}.map{|e| e.messages}.each do |sizes_messages|
        errors.messages.merge! sizes_messages
      end
    end
  end

  association :sizes, Panel::Wizards::UpdateSizeForm

  private
  def set_sizes(attributes)
    attributes.map do |i, params|
      Panel::Wizards::UpdateSizeForm.new(params.except(:_destroy)) unless params[:_destroy] == 'true'
    end.compact
  end

  def defaults
    { sizes: [] }
  end

  def at_lest_one_image
    if temp_image_ids.blank?
      errors[:base] << 'At least one image for each variant must be present'
    end
  end

  def at_lest_one_size
    if sizes.blank?
      errors[:base] << 'At least one size for each variant must be present'
    end
  end
end

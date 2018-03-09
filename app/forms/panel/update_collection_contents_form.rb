class Panel::UpdateCollectionContentsForm
  include ActiveModel::Model

  attr_accessor(
    :collection_contents, :id
  )

  validate  :at_least_one_collection_content

  def initialize(collection_attrs, form_attributes = {})
    @attributes = collection_attrs.merge(form_attributes)
    super @attributes
  end

  def collection_contents_attributes=(attributes)
    @collection_contents = set_collection_contents(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :collection_contents, CollectionContent

  private
  def set_collection_contents(attributes)
    attributes.map do |i, params|
      CollectionContent.new(params.except(:_destroy)) if params[:_destroy] == 'false'
    end.compact
  end

  def at_least_one_collection_content
    if collection_contents.blank?
      errors[:collection_contents] << '- at least one must be present'
    end
  end
end

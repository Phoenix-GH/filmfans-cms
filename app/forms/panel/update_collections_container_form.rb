class Panel::UpdateCollectionsContainerForm
  include ActiveModel::Model

  attr_accessor(
    :id, :name, :collection_ids, :linked_collections
  )

  def initialize(collections_container_attrs, form_attributes = {})
    super collections_container_attrs.merge(form_attributes)
  end

  validates :name, presence: true
  validate :at_least_one_linked_collection

  def collections_container_attributes
    {
      name: name,
      collection_ids: collections_linked
    }
  end

  def collections_linked
    if collection_ids
      collection_ids.split(",")
    else
      collections_container = CollectionsContainer.find(id)
      collections_container ? collections_container.collection_ids : []
    end
  end

  def linked_collections_attributes=(attributes)
    @linked_collections = set_linked_collections(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = { klass: @@attributes[association] }
    OpenStruct.new data
  end

  association :linked_collections, LinkedCollection

  private

  def set_linked_collections(attributes)
    attributes.map do |i, params|
      LinkedCollection.new(params)
    end.compact
  end

  def at_least_one_linked_collection
    if linked_collections.blank?
      errors[:linked_collections] << '- at least one must be present'
    end
  end
end

class Panel::CreateCollectionsContainerForm
  include ActiveModel::Model

  attr_accessor(
    :name, :collection_ids, :linked_collections
  )

  validates :name, presence: true
  validate :at_least_one_linked_collection

  def initialize(attributes = {})
    @attributes = defaults.merge(attributes)
    super(@attributes)
  end

  def collections_container_attributes
    {
      name: name,
      collection_ids: collections_linked
    }
  end

  def collections_linked
    collection_ids ? collection_ids.split(",") : []
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

  def defaults
    { linked_collections: [] }
  end

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

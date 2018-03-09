class CollectionsContainerSerializer
  def initialize(collections_container)
    @collections_container = collections_container
  end

  def results
    return '' unless @collections_container
    generate_collections_container_json
  end

  private

  def generate_collections_container_json
    {
      type: 'collections_container',
      name: @collections_container.name.to_s,
      collections: generate_collections
    }
  end

  def generate_collections
    @collections_container.linked_collections.order(:position).map do |linked_collection|
      CollectionSerializer.new(linked_collection.collection).results if linked_collection.collection.present?
    end.compact
  end
end

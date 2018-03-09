class Panel::CreateLinkedCollectionService
  def initialize(container, linked_collections = [])
    @container = container
    @linked_collections = linked_collections
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_linked_collections
      create_new_linked_collections
    end
  end

  private
  def remove_old_linked_collections
    @container.linked_collections.delete_all
  end

  def create_new_linked_collections
    @linked_collections.each do |linked_collection|
      position = linked_collection[:position]
      collection = Collection.find_by(id: linked_collection[:collection_id])
      if collection
        @container.linked_collections.create(collection: collection, position: position)
      end
    end
  end
end

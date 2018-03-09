class Panel::SortCollectionsContainerService
  def initialize(collections_container, params)
    @collections_container = collections_container
    @params = params
  end

  def call
    update_all_positions
  end

  private

  def update_all_positions
    @params.each do |key, value|
      @collections_container.linked_collections
        .find_by(collection_id: value[:id])
        .update_attribute(:position ,value[:position])
    end
  end
end

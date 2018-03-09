class Panel::DestroyCollectionsContainerService
  def initialize(collections_container)
    @collections_container = collections_container
  end

  def call
    destroy_collections_container
    destroy_relations
  end

  private

  def destroy_collections_container
    @collections_container.destroy
  end

  def destroy_relations
    HomeContent.where(content: @collections_container).delete_all
    TrendingContent.where(content: @collections_container).delete_all
  end
end

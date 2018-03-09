class Panel::DestroyMediaOwnerTrendingContainerService
  def initialize(media_owner_trending_container)
    @media_owner_trending_container = media_owner_trending_container
  end

  def call
    destroy_media_owner_trending_container
    destroy_relations
  end

  private

  def destroy_media_owner_trending_container
    @media_owner_trending_container.destroy
  end

  def destroy_relations
    HomeContent.where(content: @media_owner_trending_container).delete_all
    TrendingContent.where(content: @media_owner_trending_container).delete_all
  end
end

class Panel::DestroyMoviesContainerService
  def initialize(movies_container)
    @movies_container = movies_container
  end

  def call
    destroy_movies_container
    destroy_relations
  end

  private

  def destroy_movies_container
    @movies_container.destroy
  end

  def destroy_relations
    HomeContent.where(content: @movies_container).delete_all
    TrendingContent.where(content: @movies_container).delete_all
  end
end

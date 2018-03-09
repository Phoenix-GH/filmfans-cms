class Panel::DestroyEventsContainerService
  def initialize(events_container)
    @events_container = events_container
  end

  def call
    destroy_events_container
    destroy_relations
  end

  private

  def destroy_events_container
    @events_container.destroy
  end

  def destroy_relations
    HomeContent.where(content: @events_container).delete_all
    TrendingContent.where(content: @events_container).delete_all
  end
end

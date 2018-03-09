class PostQuery < BaseQuery
  def initialize(source_owner, filters = {})
    @source_owner = source_owner
    @filters = filters
  end

  def results
    prepare_query
    source_filter
    order_results('published_at', 'desc')

    @results
  end

  private

  def prepare_query
    if filters[:page]
      @results = @source_owner.all_posts.page(filters[:page])
    else
      @results = @source_owner.all_posts.page(1)
    end
  end

  def source_filter
    return if filters[:source_id].blank?

    @results = @results.where(source_id: filters[:source_id])
  end
end

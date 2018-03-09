class TvShowQuery < BaseQuery
  def results
    prepare_query
    channel_filter
    search_result('title')
    visibility_filter
    current_country_filter
    order_results('position', 'desc')
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = TvShow.all
  end

  def channel_filter
    if filters[:channel_id].present?
      @results = @results.where(channel_id: filters[:channel_id])
    elsif filters[:channel_ids].present?
      @results = @results.where(channel_id: filters[:channel_ids])
    end
  end

  def visibility_filter
    return if filters[:visibility].blank?

    @results = @results.joins(:channel).where(channels: {visibility: filters[:visibility]})
  end

  def current_country_filter
    return if filters[:current_country].blank?

    # jsonb array query (postgres syntax)
    @results = @results.
        joins(:channel).
        where("countries @> ? or countries = '[]'", "[\"#{filters[:current_country].downcase}\"]")
  end
end

class ChannelQuery < BaseQuery
  def results
    prepare_query
    category_filter
    channel_filter
    visibility_filter
    current_country_filter
    country_filter
    search_result
    normal_filter
    key_filter
    order_results
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = Channel.all
  end

  def channel_filter
    return if filters[:channel_ids].blank?

    @results = @results.where(id: filters[:channel_ids],)
  end

  def visibility_filter
    return if filters[:visibility].blank?

    @results = @results.where(visibility: filters[:visibility])
  end

  # used by mobile apps
  def current_country_filter
    return if filters[:current_country].blank?

    # jsonb array query (postgres syntax)
    @results = @results.where("countries @> ? or countries = '[]'", "[\"#{filters[:current_country].downcase}\"]")
  end

  # used by CMS channel list
  def country_filter
    return if filters[:country].blank?

    if filters[:country] == Country::CODE_GLOBAL
      @results = @results.where("countries = '[]'")
    else
      @results = @results.where('countries @> ?', "[\"#{filters[:country]}\"]")
    end
  end

  def category_filter
    return if filters[:category_id].blank?

    @channel_ids = ChannelForCategoryQuery.new(filters[:category_id]).results
    @results = @results.where(id: @channel_ids)
  end

  def normal_filter
    return if filters[:normal].blank?
    @results = @results.where(key: nil)
  end

  def key_filter
    return if filters[:key].blank?
    @results = @results.where(key: filters[:key].upcase)
  end

  def order_results(default_sort = 'position', default_direction = 'desc')
    if filters[:sort] == 'media_owners'
      direction = filters[:direction].presence || 'asc'
      @results = @results.
        joins('LEFT JOIN channel_media_owners ON channel_media_owners.channel_id = channels.id').
        group('channels.id').
        order("count(channel_media_owners.id) #{direction}")
    else
      super(default_sort, default_direction)
    end
  end
end

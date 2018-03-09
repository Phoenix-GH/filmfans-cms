class ManualPostQuery < BaseQuery
  def results
    prepare_query
    media_owner_filter
    channel_filter
    visible_filter
    trending_filter
    video_filter
    search_result
    order_results('created_at', 'desc')
    paginate_result

    @results
  end

  private
  def prepare_query
    if filters[:timestamp].blank?
      @results = ManualPost.all
    else
      @results = ManualPost.until(filters[:timestamp].to_i)
    end
  end

  def media_owner_filter
    return if filters[:media_owner_id].blank?

    media_owner = MediaOwner.find_by(id: filters[:media_owner_id], feed_active: true)

    if media_owner.blank?
      @results = ManualPost.none
    else
      @results = @results.where(media_owner_id: filters[:media_owner_id])
    end
  end

  def channel_filter
    return if filters[:channel_id].blank?

    channel = Channel.find_by(id: filters[:channel_id], feed_active: true, visibility: true)

    if channel.blank?
      @results = ManualPost.none
    else
      @results = channel.all_manual_posts
    end
  end

  def visible_filter
    return if filters[:visible].blank?
    @results = @results.where(visible: filters[:visible])
  end

  def trending_filter
    return if filters[:trending].blank?
    @results = @results.media_owners.trending
  end

  def video_filter
    return if filters[:video].blank?
    @results = @results.where.not(:video => nil)
  end

  def paginate_result
    if filters[:number_of_posts].blank?
      super
    else
      @results = @results.first(filters[:number_of_posts].to_i)
    end
  end
end

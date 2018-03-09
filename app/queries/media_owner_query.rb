class MediaOwnerQuery < BaseQuery
  def results
    prepare_query
    media_owner_filter
    category_filter
    channel_filter
    feed_active_filter
    search_result
    order_results('position', 'desc')
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = MediaOwner.all.includes(:picture)
  end

  def order_results(name, direction)
    return super(name, direction) unless filters[:sort] == 'followings'

    @results = @results
      .joins("LEFT JOIN followings ON followings.followed_id = media_owners.id AND followings.followed_type = 'MediaOwner'")
      .select('media_owners.*, COUNT(followings.id) AS followings_count')
      .group(:id)
      .order('followings_count desc')
  end

  def channel_filter
    return if filters[:channel_id].blank?

    @results = @results.includes(:channel_media_owners)
      .where(channel_media_owners: { channel_id: filters[:channel_id] })
  end

  def category_filter
    return if filters[:category_id].blank?

    @media_owners_ids = MediaOwnerForCategoryQuery.new(filters[:category_id]).results
    @results = @results.where(id: @media_owners_ids)
  end

  def media_owner_filter
    return if filters[:media_owner_ids].nil?

    @results = @results.where(id: filters[:media_owner_ids])
  end

  def feed_active_filter
    return if filters[:feed_active].nil?

    @results = @results.where(feed_active: filters[:feed_active])
  end
end

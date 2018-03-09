class MediaContainerQuery < BaseQuery
  def results
    prepare_query
    date_filter
    media_content_type_filter
    media_owner_filter
    ability_filter
    channel_filter
    owner_filter
    search_result('media_containers.name')
    order_results('created_at')
    video_filter
    paginate_result

    @results
  end

  private

  def prepare_query
    @results = MediaContainer.all
  end

  def ability_filter
    return if filters[:channel_ids].nil? && filters[:media_owner_ids].nil?

    @results = @results
      .where('(owner_id IN (?) AND owner_type = ?) OR (owner_id IN (?) AND owner_type = ?)', filters[:channel_ids], 'Channel', filters[:media_owner_ids], 'MediaOwner')
  end

  def date_filter
    return if filters[:last_date].blank?

    @results = @results.where("created_at < ?", filters[:last_date])
  end

  def media_owner_filter
    if filters[:media_owner_id].present?
      @results = @results.where(owner_id: filters[:media_owner_id], owner_type: 'MediaOwner')
    elsif filters[:with_media_owner]
      @results = @results.where(owner_type: 'MediaOwner')
    end
  end

  def channel_filter
    if filters[:channel_id].present?
      @results = @results.where(owner_id: filters[:channel_id], owner_type: 'Channel')
    elsif filters[:with_channel]
      @results = @results.where(owner_type: 'Channel')
    end
  end

  def owner_filter
    if filters[:owner_id].present?
      @results = @results.where(owner_id: filters[:owner_id], owner_type: ['Channel', 'MediaOwner'])
    end
  end

  def media_content_type_filter
    return if filters[:media_content_type].blank?

    @results = @results.joins(:media_content)
      .where("media_contents.file_type ILIKE ?" , "%#{filters[:media_content_type]}%")
  end

  def video_filter
    ids = @results.joins(:media_content).where('media_contents.file_type LIKE ?', 'video/%').map(&:id)
    @results = @results.where(id: ids)
  end
end

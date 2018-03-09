class BaseQuery
  DEFAULT_PAGE_SIZE = 25

  attr_accessor :filters

  def initialize(filters = {})
    @filters = filters
  end

  def page
    (filters[:page] || 1).to_i
  end

  def per
    (filters[:per] || BaseQuery::DEFAULT_PAGE_SIZE).to_i
  end

  def offset
    (page - 1) * per
  end

  def filter_by_sql(column, value)
    return '' if column.blank? or value.blank?

    ActiveRecord::Base.send(:sanitize_sql_array, [
        "where #{column.downcase} like ?", "%#{value}%"
    ])
  end

  def order_sql(default_sort = 'name', default_direction = 'asc')
    direction = filters[:direction].presence || default_direction
    sort = filters[:sort].presence || default_sort

    "order by #{sort} #{direction}"
  end

  def paging_sql
    "limit #{per} offset #{offset}"
  end

  protected
  def search_result(default = 'name')
    return if filters[:search].blank?

    if filters[:search_exact]
      @results = @results.where("LOWER(CAST( #{default} AS text )) = ?", "#{filters[:search].downcase}")
    else
      @results = @results.where("LOWER(CAST( #{default} AS text )) LIKE ?", "%#{filters[:search].downcase}%")
    end
  end

  def channel_filter
    if filters[:channel_id].present?
      @results = @results.where(channel_id: filters[:channel_id])
    elsif filters[:with_channel]
      @results = @results.where.not(channel_id: nil)
    end
  end

  def admin_filter
    return if filters[:admin_id].blank?
    return if Admin.find(filters[:admin_id]).role >= Role::Admin

    @results = @results.where(admin_id: filters[:admin_id])
  end

  def ability_filter
    return if filters[:channel_ids].blank? && filters[:media_owner_ids].blank?

    @results = @results
      .where("channel_id IN (?) OR media_owner_id IN (?)", filters[:channel_ids], filters[:media_owner_ids])
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    direction = filters[:direction].presence || default_direction
    sort = filters[:sort].presence || default_sort

    @results = @results.order(sort => direction)
  end

  def paginate_result
    return if filters[:no_paging]

    if @results.is_a? Array
      @results = Kaminari.paginate_array(@results, total_count: @results.size).page(page).per(per)
    else
      @results = @results.page(page).per(per)
    end
  end
end

class MovieCelebrityMappingQuery < BaseQuery
  def results
    prepare_query
    filter_name
    filter_instagram_status
    order_results
    paginate_result

    @results
  end

  private


  def prepare_query
    @results = MovieCelebrityMapping.all
  end

  def filter_name
    return if filters[:name].blank?
    @results = @results.where('name_lower like ?', "#{filters[:name].downcase}%")
  end

  def filter_instagram_status
    return if filters[:instagram_status].blank?
    if filters[:instagram_status] == 'not-yet-processed'
      @results = @results.where(instagram_status: nil).where(instagram_id: nil)
    elsif filters[:instagram_status] == 'has-instagram-followed'
      @results = @results.where(instagram_status: nil).where.not(instagram_id: nil)
    else
      @results = @results.where(instagram_status: filters[:instagram_status])
    end
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort].blank?
      super(default_sort, default_direction)
    elsif filters[:sort] == 'instagram'
      # additional order
      @results = @results.order('instagram_id' => filters[:direction].presence || default_direction, 'name' => 'asc')
    else
      super(default_sort, default_direction)
    end
  end
end
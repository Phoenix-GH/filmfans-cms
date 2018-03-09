class HomeQuery < BaseQuery
  def results
    prepare_query
    published_filter
    home_type_filter
    search_result
    order_results('created_at')

    @results
  end

  private

  def prepare_query
    @results = Home.all
  end

  def published_filter
    return if filters[:published].blank?

    @results = @results.where(published: filters[:published])
  end

  def home_type_filter
    return if filters[:home_type].blank?

    @results = @results.where(home_type: Home.home_types[filters[:home_type]])
  end

  def order_results(default_sort = 'name', default_direction = 'asc')
    if filters[:sort] == 'home_contents'
      direction = filters[:direction].presence || default_direction
      @results = @results.
        joins('LEFT JOIN home_contents ON home_contents.home_id = homes.id').
        group('homes.id').
        order("count(home_contents.id) #{direction}")
    elsif filters[:sort] == 'products'
      direction = filters[:direction].presence || default_direction
      @results = @results.sort_by(&:products_count)
      @results.reverse! if direction == 'desc'
    else
      super(default_sort)
    end
  end
end

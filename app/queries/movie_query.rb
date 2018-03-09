class MovieQuery < BaseQuery
  def results
    prepare_query
    search_result('title')
    genre_filter
    order_results('created_at')
    paginate_result

    @results
  end

  private

  def genre_filter
    if filters[:genre_id].present?
      @results = @results.joins(:genres).where("genres.id = ?", filters[:genre_id])
    end
  end


  def prepare_query
    @results = Movie.where('title IS NOT NULL')
  end

  def order_results(default_sort = 'title', default_direction = 'asc')
    super(default_sort)
  end
end

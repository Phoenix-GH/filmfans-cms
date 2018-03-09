class ManualTrainingQuery < BaseQuery
  def results
    prepare_query
    paginate_result

    @results
  end

  private
  def prepare_query
    @results = ManualTraining.all.joins(:product).order("products.name #{filters[:direction].blank? ? 'asc' : filters[:direction]}")
  end

end
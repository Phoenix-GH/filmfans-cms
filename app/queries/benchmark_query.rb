class BenchmarkQuery < BaseQuery
  def results
    prepare_query
    filter_review
    filter_sent_to_ma
    filter_like
    filter_sub_benchmark
    order_results('created_at', 'desc')
    paginate_result

    @results
  end

  protected
  def prepare_query
    benchmark_key = filters[:benchmark_key] || 'CROP_AND_SHOP'
    @results = ExecutionBenchmark.where(benchmark_key: benchmark_key).all
  end

  private
  def filter_review
    return if filters[:review].blank?
    if filters[:review] == 'NA'
      @results = @results.where(review: nil).where.not(image: nil)
    else
      @results = @results.where(review: filters[:review])
    end
  end

  def filter_sent_to_ma
    return if filters[:sent_to_ma].blank?
    @results = @results.where(sent_to_ma: filters[:sent_to_ma])
  end

  def filter_like
    return if filters[:like].blank?
    @results = @results.where(like: filters[:like])
  end

  def filter_sub_benchmark
    return if filters[:include_sub]
    @results = @results.where(main: true)
  end
end


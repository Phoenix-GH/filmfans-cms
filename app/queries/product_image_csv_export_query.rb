class ProductImageCsvExportQuery < BaseQuery
  def results
    prepare_query
    system_filter
    running_filter
    used_filter
    min_id_filter
    order_results('created_at', 'desc')
    paginate_result

    @results
  end

  def prepare_query
    @results = ProductImageCSVExport.all
  end

  def system_filter
    return if filters[:system].blank?
    @results = @results.where('system like ?', "#{filters[:system]}%")
  end

  def running_filter
    return if filters[:running].blank?
    @results = @results.where(running: filters[:running])
  end

  def used_filter
    return if filters[:used].blank?
    @results = @results.where(used: filters[:used])
  end

  def min_id_filter
    return if filters[:min_id].blank?
    @results = @results.where('id >= ?', "#{filters[:min_id]}")
  end
end
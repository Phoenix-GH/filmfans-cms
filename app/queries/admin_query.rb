class AdminQuery < BaseQuery
  def results
    prepare_query
    role_filter
    search_result('email')
    order_results('id')

    @results
  end

  private

  def prepare_query
    @results = Admin.all
  end

  def role_filter
    return if filters[:role].blank?

    @results = @results.where(role: filters[:role])
  end
end

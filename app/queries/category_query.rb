class CategoryQuery < BaseQuery
  def results
    prepare_query
    parent_filter
    search_result
    order_results('name', 'asc')

    @results
  end

  private

  def prepare_query
    @results = Category.where.not(id: Category::QUARANTINE_CATEGORY_ID)
  end

  def parent_filter
    if filters[:parent_name].present?
      parent_name_filter
    else
      parent_id_filter
    end
  end

  def parent_name_filter
    @parent = Category.find_by(name: filters[:parent_name])
    @results = @results.where(parent_id: @parent.id)
  end

  def parent_id_filter
    @results = @results.where(parent_id: filters[:parent_id])
  end
end

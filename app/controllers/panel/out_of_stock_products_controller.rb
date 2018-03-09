class Panel::OutOfStockProductsController < Panel::BaseController

  def index
    query = OutOfStockProductQuery.new(search_params)
    @out_of_stock_links = query.results
    @total_count = query.total_count
  end

  private
  def search_params
    params.permit(:search, :sort, :direction, :page, :per)
  end

  def sort_column
    ['type'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end
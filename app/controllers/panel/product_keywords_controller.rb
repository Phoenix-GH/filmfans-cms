class Panel::ProductKeywordsController < Panel::BaseController
  def index
    @total = ProductKeyword.count
    @total_index = ProductKeywordQuery.new(
        {
            page: 1,
            per: 1
        }
    ).results.total_count
    @products = ProductKeywordQuery.new(
        {
            keywords: search_params[:single_keyword].blank? ? [] : [search_params[:single_keyword]],
            page: search_params[:page],
            per: search_params[:per]
        }).results
  end

  def search_params
    params.permit(:single_keyword, :page, :per)
  end
end
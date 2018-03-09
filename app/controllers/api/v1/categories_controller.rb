class Api::V1::CategoriesController < Api::V1::BaseController
  def index
    results = CategoryQuery.new(categories_params).results

    render json: results.map { |res| CategorySerializer.new(res).results }
  end

  def tree
    render json: CategoryTreeSerializer.new.results
  end

  private

  def categories_params
    params.permit(:parent_id, :parent_name)
  end
end

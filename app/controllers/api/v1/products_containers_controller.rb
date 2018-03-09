class Api::V1::ProductsContainersController < Api::V1::BaseController
  def show
    container = ProductsContainer.find(params[:id])

    render json: ProductsContainerSerializer.new(container).results
  end
end

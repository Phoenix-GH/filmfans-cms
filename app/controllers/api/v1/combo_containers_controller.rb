class Api::V1::ComboContainersController < Api::V1::BaseController
  def show
    container = ProductsContainer.find(params[:id])

    render json: ProductsContainerSerializer.new(container).results
  end
end

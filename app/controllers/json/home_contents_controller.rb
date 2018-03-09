class Json::HomeContentsController < ApplicationController
  def index
    collections_containers = CollectionsContainerQuery.new(search_params).results
    products_containers = ProductsContainerQuery.new(search_params).results
    #media_containers = MediaContainerQuery.new(search_params).results
    #combo_containers = ProductsContainerQuery.new(search_params.merge(with_media_owner: true)).results

    home_contents = collections_containers + products_containers# + media_containers
    render json: home_contents.map { |object|
      {
        name: object.name,
        token: "#{object.class.to_s}_#{object.id}"
      }
    }
  end

  private

  def search_params
    params.permit(:search)
  end
end

class Json::ProductsContainersController < ApplicationController
  def index
    containers = ProductsContainerQuery.new(search_params).results

    render json: containers.map { |container|
      {
        id: container.id,
        name: container.name,
        thumb: container.cover_image_url,
        thumb2: container.second_cover_image_url,
        thumb3: container.third_cover_image_url,
        thumbs: container.cover_images_urls
      }
    }
  end

  private

  def search_params
    params.permit(:search).merge(admin_id: current_admin.id)
  end
end

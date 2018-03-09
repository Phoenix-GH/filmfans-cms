class Json::CollectionsContainersController < ApplicationController
  def index
    containers = CollectionsContainerQuery.new(search_params).results

    render json: containers.map { |container|
      {
        id: container.id,
        name: container.name,
        thumb: container.cover_image_url,
        thumb2: container.second_cover_image_url,
      }
    }
  end

  private

  def search_params
    params.permit(:search).merge(admin_id: current_admin.id)
  end
end

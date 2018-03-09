class Json::MoviesContainersController < ApplicationController
  def index
    containers = MoviesContainerQuery.new(search_params).results

    render json: containers.map { |container|
      {
        id: container.id,
        name: container.name,
      }
    }
  end

  private

  def search_params
    params.permit(:search, :channel_id).merge(admin_id: current_admin.id)
  end
end

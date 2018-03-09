class Api::V1::MediaContainersController < Api::V1::BaseController
  def index
    results = MediaContainerQuery.new(media_containers_params).results

    json = results.map { |res| MediaContainerSerializer.new(res).results }

    render json: json
  end

  def show
    media_container = MediaContainer.find(params[:id])

    render json: MediaContainerSerializer.new(media_container, true).results
  end

  private

  def media_containers_params
    params.permit(:last_date, :media_owner_id, :page)
  end
end

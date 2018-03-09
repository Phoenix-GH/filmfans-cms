class Json::MediaContainersController < ApplicationController
  def index
    media_containers = MediaContainerQuery.new(search_params).results

    render json: media_containers.map { |media|
      {
        id: media.id,
        name: media.name,
        thumb: media.media_content.file_thumb_url.to_s
      }
    }
  end

  private

  def search_params
    params.permit(:search)
      .merge(channel_ids: current_admin.channel_ids)
      .merge(media_owner_ids: current_admin.media_owner_ids)
  end
end

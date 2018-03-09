class Json::MediaOwnersController < ApplicationController
  def index
    results = MediaOwnerQuery.new(media_owners_params).results

    render json: results.map { |res|
      {
        name: res.name,
        id: res.id,
        thumb: res.picture&.custom_url
      }
    }
  end

  private

  def media_owners_params
    params.permit(:channel_id, :search).merge(media_owner_ids: current_admin.media_owner_ids)
  end
end

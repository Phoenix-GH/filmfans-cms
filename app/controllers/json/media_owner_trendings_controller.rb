class Json::MediaOwnerTrendingsController < ApplicationController
  def index
    media_owner_trendings = ManualPostQuery.new(search_params).results

    render json: media_owner_trendings.map { |media_owner_trending|
      {
          id: media_owner_trending.id,
          text: media_owner_trending.name,
          image: media_owner_trending&.custom_url
      }
    }
  end

  private

  def search_params
    params.permit(:search)
  end
end

class Json::ChannelsController < ApplicationController
  def index
    results = ChannelQuery.new(channels_params).results

    render json: results.map { |res|
      {
        name: res.name,
        id: res.id,
        thumb: res.picture&.custom_url
      }
    }
  end

  private

  def channels_params
    params.permit(:search).merge(visibility: true, normal: true)
  end
end

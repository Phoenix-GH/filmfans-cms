class Json::TvShowsController < ApplicationController
  def index
    tv_shows = TvShowQuery.new(search_params).results

    render json: tv_shows.map { |tv_shows|
      {
        id: tv_shows.id,
        name: tv_shows.title,
        thumb: tv_shows.cover_image&.custom_url
      }
    }
  end

  private

  def search_params
    params.permit(:search, :channel_id)
  end
end

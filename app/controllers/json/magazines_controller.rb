class Json::MagazinesController < ApplicationController
  def index
    magazines = MagazineQuery.new(search_params).results

    render json: magazines.map { |magazine|
      {
        id: magazine.id,
        name: magazine.title,
        thumb: magazine.cover_image&.custom_url
      }
    }
  end

  private

  def search_params
    params.permit(:search, :channel_id)
  end
end

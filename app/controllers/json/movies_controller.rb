class Json::MoviesController < ApplicationController
  def index
    events = MovieQuery.new(search_params).results

    render json: events.map { |mv|
      {
          id: mv.id,
          text: mv.title,
          image: buil_img_url(mv, mv.poster_image_thumbnail),
          name: mv.title,
          thumb: buil_img_url(mv, mv.poster_image_thumbnail)
      }
    }
  end

  private

  def buil_img_url(mv, url)
    return url if mv.gracenote_id.blank?
    GracenoteMoveDetailSerializer::full_image_url(url)
  end

  def search_params
    params.permit(:search).merge(admin_id: current_admin.id)
  end
end

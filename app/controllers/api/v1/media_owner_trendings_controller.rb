class Api::V1::MediaOwnerTrendingsController < Api::V1::BaseController
  before_action :authenticate_if_token, only: [:index]

  def index
    render json: {
        social_media_containers: media_owner_trendings.map { |res| ManualPostSerializer.new(res).result_embed_one_product }
    }
  end

  def carousels
    # Filter only media owners that have manual post with display option: 'Celebrity Trending only'/'Both'
    render json: Api::V1::ManualPostCarouselService.new.list_media_owner_having_manual_posts(current_api_v1_user)
  end

  private

  def media_owner_trendings_params
    params.permit(:media_owner_id, :video, :number_of_posts, :timestamp)
  end

  def media_owner_trendings
    params = media_owner_trendings_params
    if params[:timestamp].blank?
      params = params.merge({timestamp: Time.now.to_i})
    end
    if params[:number_of_posts].blank?
      params = params.merge({number_of_posts: 25})
    end

    ManualPostQuery.new(params.merge({visible: true, trending: true})).results
  end
end
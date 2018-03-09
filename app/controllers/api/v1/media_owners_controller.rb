class Api::V1::MediaOwnersController < Api::V1::BaseController
  before_action :authenticate_if_token, only: [:index]
  before_filter :find_media_owner, only: [:show, :feed, :videos]

  def index
    parameters = media_owners_params.merge({ feed_active: true })
    if parameters[:page].blank?
      parameters = parameters.merge({no_paging: true})
    end

    results = MediaOwnerQuery.new(parameters).results

    render json: results.map { |res| MediaOwnerSerializer.new(res, false, current_api_v1_user).results }
  end

  def show
    render json: MediaOwnerSerializer.new(@media_owner, true).results
  end

  def feed
    render json: SocialFeedSerializer.new(@media_owner, params).results
  end

  def videos
    render json: VideosSerializer.new(@media_owner, params).results
  end

  def discovery
    render json: DiscoverySerializer.new(MediaOwner, params).results
  end

  private

  def find_media_owner
    @media_owner = MediaOwner.find(params[:id])
  end

  def media_owners_params
    params.permit(:search, :sort, :page, :per, :category_id, channel_id: [])
  end
end

class Api::V1::ChannelsController < Api::V1::BaseController
  before_action :authenticate_if_token, only: [:index]
  before_filter :find_channel, only: [:show, :feed, :videos, :trending]

  def index
    parameters = channels_params
    if parameters[:page].blank?
      parameters = parameters.merge({no_paging: true, normal: true})
    end

    results = ChannelQuery.new(parameters).results

    render json: results.map { |res| ChannelSerializer.new(res, current_api_v1_user).results }
  end

  def show
    render json: ChannelSerializer.new(@channel).results
  end

  def feed
    render json: SocialFeedSerializer.new(@channel, params).results
  end

  def feed_by_key
    key = params[:key].blank? ? '' : params[:key]
    @channel = Channel.where({key: key}).first

    if @channel.blank?
      result = {}
    else
      result = SocialFeedSerializer.new(@channel, params).results
    end
    render json: result
  end

  def videos
    render json: VideosSerializer.new(@channel, params).results
  end

  def discovery
    render json: DiscoverySerializer.new(Channel, params).results
  end

  def trending
    render json: TrendingSerializer.new(@channel.trending).results
  end

  private

  def find_channel
    @channel = Channel.find(params[:id])
  end

  def channels_params
    params.permit(:sort, :page, :per, :category_id, :current_country, :key).merge(visibility: true)
  end
end

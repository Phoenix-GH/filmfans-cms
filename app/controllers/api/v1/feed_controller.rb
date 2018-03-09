class Api::V1::FeedController < Api::V1::BaseController
  def index
    feed = FeedQuery.new(feed_params).results

    render json: FeedSerializer.new(feed).results
  end

  private

  def feed_params
    params.permit(
      :search,
      :page,
      :with_media_owner,
      :with_channel,
      channel_id: [],
      media_owner_id: []
    )
  end
end

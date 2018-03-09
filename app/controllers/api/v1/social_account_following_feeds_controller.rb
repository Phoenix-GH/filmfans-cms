class Api::V1::SocialAccountFollowingFeedsController < Api::V1::BaseController
  def index
    social_feeds = Social::SocialService.new.get_feeds(
        following_ids: search_params[:following_ids],
        timestamp: search_params[:timestamp],
        number_of_posts: search_params[:number_of_posts]
    )

    new_social_feeds = social_feeds.map { |social_feed|
      {
          id: social_feed['id'],
          date: social_feed['date'],
          post_type: social_feed['post_type'],
          content_title: social_feed['content_title'],
          content_body: social_feed['content_body'],
          post_url: social_feed['post_url'],
          website: social_feed['website'],
          owner: complement_owner(social_feed['owner']),
          content: social_feed['content']
      }
    }
    results = new_social_feeds.map { |social_feed| SocialAccountFollowingFeedSerializer.new(social_feed).results }
    render json: { social_media_containers: results }
  end

  private

  def search_params
    if request.method == 'GET'
      params.permit(:timestamp, :number_of_posts, :following_ids)
    else
      params.permit(:timestamp, :number_of_posts, :following_ids => [])
    end
  end

  def complement_owner(owner)
    return owner if owner.blank?
    return owner unless owner['name'].blank? || owner['thumbnail_url'].blank?
    target_id = owner['loginname']
    return owner if target_id.blank?

    @accounts ||= {}

    if @accounts[target_id].blank?
      following = SocialAccountFollowing.find_by(target_id: target_id)
      unless following.blank?
        @accounts[target_id] = following
      end
    end

    return owner if @accounts[target_id].blank?

    owner['name'] = @accounts[target_id].name
    owner['thumbnail_url'] = @accounts[target_id].avatar_url

    owner
  end

end
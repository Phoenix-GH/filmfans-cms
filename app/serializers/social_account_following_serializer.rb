class SocialAccountFollowingSerializer
  def initialize(following)
    @following = following
  end

  def results
    return {} unless @following
    serialize
  end

  private
  def serialize
    {
        id: @following.id,
        name: @following.name,
        avatar_url: @following.avatar_url,
        web_url: @following.web_url,
        target_id: @following.target_id,
        information: {
            followed_by: @following.followers_num,
            number_posts: @following.posts_num
        }
    }
  end
end

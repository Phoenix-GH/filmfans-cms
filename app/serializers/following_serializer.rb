class FollowingSerializer
  def initialize(user, followed)
    @user = user
    @followed = followed
  end

  def results
    return [] unless @followed
    generate_following_json
  end

  private

  def generate_following_json
    {
      isfollowing: @user.is_following?(@followed),
      followers: @followed.followings.count,
      followed_name: @followed.name
    }
  end

end

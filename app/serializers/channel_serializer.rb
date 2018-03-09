class ChannelSerializer
  def initialize(channel, user = nil)
    @channel = channel
    @user = user
  end

  def results
    return '' unless @channel
    generate_channel_json
    add_followed_flag

    @channel_json
  end

  private
  def generate_channel_json
    @channel_json = {
      id: @channel.id,
      name: @channel.name.to_s,
      thumbnail_url: @channel.picture.present? ? @channel.picture.custom_url : '',
      image_url: @channel.picture.present? ? @channel.picture.custom_url : '',
      feed: @channel.feed_active?,
      magazines: @channel.magazines.any?,
      tv_shows: @channel.tv_shows.any?
    }
  end

  def add_followed_flag
    return if @user.blank?

    @channel_json.merge!(
      is_followed: @user.is_following?(@channel)
    )
  end
end

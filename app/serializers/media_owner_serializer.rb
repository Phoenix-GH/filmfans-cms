class MediaOwnerSerializer
  def initialize(media_owner, with_details = false, user = nil)
    @media_owner = media_owner
    @with_details = with_details
    @user = user
  end

  def results
    return '' unless @media_owner
    generate_media_owner_json
    add_details
    add_followed_flag

    @media_owner_json
  end

  private
  def generate_media_owner_json
    @media_owner_json = {
      id: @media_owner.id,
      name: @media_owner.name.to_s,
      thumbnail_url: @media_owner.picture.present? ? @media_owner.picture.custom_url : ''
    }
  end

  def add_details
    return unless @with_details

    @media_owner_json.merge!(
      image_url: @media_owner.picture.present? ? @media_owner.picture.custom_url : '',
      url: @media_owner.url.to_s,
      background_image_url: @media_owner.background_image.present? ? @media_owner.background_image.custom_url : '',
      channels: generate_channels_json,
      feed: @media_owner.feed_active?
    )
  end

  def generate_channels_json
    @media_owner.channels.map {
      |channel| ChannelSerializer.new(channel).results
    }
  end

  def add_followed_flag
    return if @user.blank?

    @media_owner_json.merge!(
      is_followed: @user.is_following?(@media_owner)
    )
  end
end

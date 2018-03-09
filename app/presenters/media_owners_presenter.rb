class MediaOwnersPresenter
  def owner_options
    channels = Channel.all.map { |channel| [channel.name, "Channel:#{channel.id}"] }
    media_owners = MediaOwner.all.map { |media_owner| [media_owner.name, "MediaOwner:#{media_owner.id}"] }
    channels + media_owners
  end

  def media_owner_trending_display_options
    channels = []
    channels << ["Celebrity fashion only", ManualPost::DISPLAY_TRENDING_ONLY]
    channels << ["Social post only", ManualPost::DISPLAY_SOCIAL_ONLY]
    channels << ["Both", ManualPost::DISPLAY_BOTH]
  end
end
class Panel::UpdateChannelService
  def initialize(channel, form)
    @channel = channel
    @form = form
  end

  def call
    return false unless @form.valid?

    update_channel
  end

  private

  def update_channel
    @channel.update_attributes(@form.attributes)
    @channel.picture.update_attributes(@form.picture_attributes)
  end
end

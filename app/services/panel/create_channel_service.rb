class Panel::CreateChannelService
  attr_reader :channel

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      create_channel
      create_picture
      add_channel_moderator
    end
  end

  private

  def create_channel
    @channel = Channel.create(@form.attributes)
    # so that it will be displayed on top
    @channel.position = @channel.id
    @channel.save
  end

  def create_picture
    @channel.create_picture(@form.picture_attributes)
  end

  def add_channel_moderator
    if @user.role == 'moderator'
      ChannelModerator.create(channel_id: @channel.id, admin_id: @user.id)
    end

    true
  end
end

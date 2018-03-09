class Panel::ToggleFollowingService
  attr_reader :followed

  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    add_followed
    toggle_following
  end

  private

  def add_followed
    if @form.following_attributes[:followed_type] == 'Channel'
      @followed = Channel.find_by(id: @form.following_attributes[:followed_id])
    elsif @form.following_attributes[:followed_type] == 'MediaOwner'
      @followed = MediaOwner.find_by(id: @form.following_attributes[:followed_id])
    end
  end

  def toggle_following
    if following = Following.find_by(@form.following_attributes)
      following.destroy
    else
      Following.create(@form.following_attributes)
    end
  end

end

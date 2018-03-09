class Panel::CreateEventDetailsService
  attr_reader :event

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_event
    create_background_image
    create_cover_image
    add_admin_id
  end

  private

  def create_event
    @event = Event.create(@form.attributes)
  end

  def create_background_image
    @event.create_background_image(@form.background_image_attributes)
  end

  def create_cover_image
    @event.create_cover_image(@form.cover_image_attributes)
  end

  def add_admin_id
    if @user.role == 'moderator'
      @event.update_attributes(admin_id: @user.id)
    end

    true
  end
end

class Panel::CreateMediaOwnerService
  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_media_owner
    create_picture
    create_background_image
    add_media_owner_moderator
  end

  private

  def create_media_owner
    @media_owner = MediaOwner.create(@form.attributes)
  end

  def create_picture
    @media_owner.create_picture(@form.picture_attributes)
  end

  def create_background_image
    @media_owner.create_background_image(@form.background_image_attributes)
  end

  def add_media_owner_moderator
    if @user.role == 'moderator' || @user.role == 'curator'
      MediaOwnerModerator.create(media_owner_id: @media_owner.id, admin_id: @user.id)
    end

    true
  end
end

require 'rack/mime'

class Api::V1::UpdateUserProfileService
  def initialize(user, form)
    @user = user
    @form = form
  end

  def call
    return false unless @form.valid?

    update_profile

    @profile
  end

  private

  def update_profile
    @profile = Profile.find_or_create_by(user: @user)

    # Keep the current values if attributes don't exist
    form_attributes = @form.user_profile_attributes

    if form_attributes[:picture]
      picture_data = Base64ImageHelper.decode_picture(form_attributes[:picture])
      @profile.picture = picture_data
    end

    @profile.name = form_attributes[:name] ? form_attributes[:name] : @profile.name
    @profile.surname = form_attributes[:surname] ? form_attributes[:surname] : @profile.surname
    @profile.sex = form_attributes[:sex] ? (form_attributes[:sex].blank? ? nil : form_attributes[:sex]) : @profile.sex
    @profile.birthday = form_attributes[:birthday] ? form_attributes[:birthday] : @profile.birthday

    @profile.save!
  end
end

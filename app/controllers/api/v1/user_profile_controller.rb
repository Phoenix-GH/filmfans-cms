class Api::V1::UserProfileController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!, only: [:update]

  def update
    @form = Api::V1::UpdateUserProfileForm.new(user_profile_form_params)
    service = Api::V1::UpdateUserProfileService.new(current_api_v1_user, @form)

    if service.call
      render_update_success
    else
      render_update_error
    end
  end

  private
  def render_update_success
    render json: {
      status: 'success',
      data:   current_api_v1_user.as_json
        .merge(ProfileSerializer.new(current_api_v1_user.profile).results)
    }
  end

  def render_update_error
    render json: {
      status: 'error',
      errors: @form.errors.to_hash.merge(full_messages: @form.errors.full_messages)
    }, status: 422
  end

  private
  def user_profile_form_params
    params.permit(:name, :surname, :sex, :birthday, :picture)
  end
end

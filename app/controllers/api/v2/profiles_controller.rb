class Api::V2::ProfilesController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update]

  def update

    @form = Api::V1::UpdateUserProfileForm.new(user_profile_params)
    service = Api::V1::UpdateUserProfileService.new(current_user, @form)

    @profile = service.call

    if @profile

      # Update user profile info on ulab server
      params = user_profile_params.merge({ :login_token => current_user.ulab_access_token, :picture_name => @profile.picture.identifier.to_s })

      ulab_results = Api::V2::UlabService.new(params).update_user

      if ulab_results[:status_code].blank? or ulab_results[:status_code].to_i != 200
        Rails.logger.info "==> Ulab profile update failed with response data: #{ulab_results}"
      end

      render_update_success
    else
      render_update_error
    end
  end

  private
  def render_update_success
    render json: {
      status: 'success',
      data: current_user.as_json.merge(ProfileSerializer.new(current_user.profile).results)
    }
  end

  def render_update_error
    render json: {
      status: 'error',
      errors: [I18n.t("application.profiles.update_failed")]
    }, status: 422
  end

  def render_ulab_update_error
    render json: {
        status: 'error',
        errors: [I18n.t("application.profiles.update_failed")]
    }, status: 422
  end

  def user_profile_params
    params.permit(:name, :surname, :sex, :birthday, :picture)
  end
end

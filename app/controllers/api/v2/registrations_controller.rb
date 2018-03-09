class Api::V2::RegistrationsController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery with: :null_session

  def create

    # Register ulab account
    return render_ulab_create_error unless register_ulab

    params.merge!(@ulab_results.slice(:ulab_user_id, :ulab_access_token))

    @resource            = resource_class.new(sign_up_params)
    @resource.provider   = "email"

    # Honor devise configuration for case_insensitive_keys
    if resource_class.case_insensitive_keys.include?(:email)
      @resource.email = sign_up_params[:email].try :downcase
    else
      @resource.email = sign_up_params[:email]
    end

    begin
      @profile_form = Api::V1::UpdateUserProfileForm.new(user_profile_params)
      service = Api::V2::CreateUserService.new(@resource, @profile_form)

      if service.call
        yield @resource if block_given?

        unless @resource.confirmed?
          # user will require email authentication
          @resource.send_confirmation_instructions({ client_config: params[:config_name], redirect_url: @redirect_url })
        else
          # email auth has been bypassed, authenticate user
          @client_id = SecureRandom.urlsafe_base64(nil, false)
          @token     = SecureRandom.urlsafe_base64(nil, false)

          @resource.tokens[@client_id] = {
              token: BCrypt::Password.create(@token),
              expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
          }

          @resource.save!

          sleep(0.5)
          UserMailer.welcome_email(@resource).deliver_now

          update_auth_header
        end
        render_create_success
      else
        clean_up_passwords @resource
        render_create_error
      end
    rescue ActiveRecord::RecordNotUnique, Api::V2::CreateUserService::CreateUserProfileFailed => e
      if e.instance_of?(ActiveRecord::RecordNotUnique)
        clean_up_passwords @resource
        render_create_error_email_already_exists
      else
        clean_up_passwords @resource
        render_create_profile_error
      end
    end
  end

  private

  def register_ulab
    full_params = user_params.merge(user_profile_params)
    unless (user_profile_params[:picture].blank?)
      decoded_picture = Base64ImageHelper.decode_picture(user_profile_params[:picture])
      full_params = full_params.merge({ picture_name: decoded_picture.original_filename })
    end

    @ulab_results = Api::V2::UlabService.new(full_params).register_user

    if (@ulab_results[:status_code].blank? or @ulab_results[:status_code].to_i != 200)
      return false
    end

    return true
  end

  def user_params
    params.permit(:email, :password)
  end

  def user_profile_params
    params.permit(:name, :surname, :sex, :birthday, :picture)
  end

  def render_create_success
    render json: {
        status: 'success',
        data: resource_data.merge({
          name: @resource.profile.name,
          surname: @resource.profile.surname,
          sex: @resource.profile.sex,
          birthday: @resource.profile.birthday,
          picture: @resource.profile.picture.url
        })
    }
  end

  def render_create_error_email_already_exists
    render json: {
        status: 'error',
        errors: [I18n.t("devise_token_auth.registrations.email_already_exists", email: @resource.email)]
    }, status: 422
  end

  def render_create_error
    render json: {
        status: 'error',
        errors: [I18n.t("devise_token_auth.registrations.unavailable")]
    }, status: 422
  end

  def render_create_profile_error
    render json: {
        status: 'error',
        errors: [I18n.t("devise_token_auth.registrations.unavailable")]
    }, status: 422
  end

  def render_ulab_create_error
    if @ulab_results[:message] == "This user already exists"
      render json: {
          status: 'error',
          errors: [I18n.t("devise_token_auth.registrations.email_already_exists", email: user_params[:email])]
      }, status: 422
    else
      render json: {
          status: 'error',
          errors: [I18n.t("devise_token_auth.registrations.unavailable")]
      }, status: 422
    end
  end

  def render_update_error
    render json: {
        status: 'error',
        errors: [resource_errors[:full_messages][0]]
    }, status: 422
  end

end

class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery with: :null_session
  def create
    ulab_params = Api::V1::RegisterInUlabService.new(user_params).call

    return render_ulab_error unless ulab_params
    params.merge!(ulab_params)

    @resource            = resource_class.new(sign_up_params)
    @resource.provider   = "email"

    # honor devise configuration for case_insensitive_keys
    if resource_class.case_insensitive_keys.include?(:email)
      @resource.email = sign_up_params[:email].try :downcase
    else
      @resource.email = sign_up_params[:email]
    end

    begin
      # override email confirmation, must be sent manually from ctrl
      resource_class.set_callback("create", :after, :send_on_create_confirmation_instructions)
      resource_class.skip_callback("create", :after, :send_on_create_confirmation_instructions)
      if @resource.save
        yield @resource if block_given?

        unless @resource.confirmed?
          # user will require email authentication
          @resource.send_confirmation_instructions({
            client_config: params[:config_name],
            redirect_url: @redirect_url
          })

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
    rescue ActiveRecord::RecordNotUnique
      clean_up_passwords @resource
      render_create_error_email_already_exists
    end
  end

  private
  def user_params
    params.permit(:email, :password)
  end

  def render_ulab_error
    render json: {
      status: 'error',
      data:   'ULAB registration error'
    }, status: 422
  end

  def render_create_success
    render json: {
      status: 'success',
      data:   resource_data
    }
  end
end

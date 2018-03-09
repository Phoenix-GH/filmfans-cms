class Api::V2::OpenAuthsController < DeviseTokenAuth::OmniauthCallbacksController
  attr_reader :auth_params
  skip_before_action :set_user_by_token, raise: false
  skip_after_action :update_auth_header

  def login
    fetch_user_data
    create_or_login
  end

  protected
  def fetch_user_data
    raise "Must override this function for specific provider"
  end

  def initialize_profile
    raise "Must override this function for specific provider"
  end

  def create_auth_params
    super

    # FB omniauth HACK due to differences in devise_token_auth gem and Facebook docs.
    # We need both access-token & auth_token, and client & client_id keys.
    @auth_params.merge!({
                            'access-token': @token,
                            client: @client_id,
                        })
  end

  def resource_class(mapping = nil)
    User
  end

  private
  def create_or_login
    @resource = User.where( uid: @user_data['id'],
                            provider: :facebook,
                            email: @user_data['email'] ).first_or_initialize

    if @resource.new_record?
      # Create user on hs & ulab and sign in
      set_random_password
      initialize_profile

      # Register ulab account
      return render_ulab_create_error unless register_ulab

      # Update ulab_user_id, ulab_access_token to new created resource
      @resource.ulab_user_id = @ulab_results[:ulab_user_id]
      @resource.ulab_access_token = @ulab_results[:ulab_access_token]

      begin
        # Register on ulab success => add account to hotspotting
        @profile_form = Api::V1::UpdateUserProfileForm.new(user_profile_params)
        service = Api::V2::CreateUserService.new(@resource, @profile_form)

        if service.call
          # Hotspotting account created => log in
          create_tokens_and_sign_in
          if @resource.save
            render_login_success
          else
            render_login_failed
          end
        else
          render_login_failed
        end
      rescue Api::V2::CreateUserService::CreateUserProfileFailed
        render_login_failed
      end

    else
      # Create token and sign in
      create_tokens_and_sign_in
      if @resource.save
        render_login_success
      else
        render_login_failed
      end
    end

    # Update email from facebook if current not set
    if @resource.email.blank? and not @user_data['email'].blank?
      Rails.logger.info "Reupdate email when available to: #{@user_data['email']}"
      @resource.email = @user_data['email']
      @resource.save

      # Update user email info on ulab server
      params = {
          :login_token => current_user.ulab_access_token,
          :new_email => @resource.email
      }

      ulab_results = Api::V2::UlabService.new(params).update_user

      if ulab_results[:status_code].blank? or ulab_results[:status_code].to_i != 200
        Rails.logger.info "Ulab profile update failed with response data: #{ulab_results}"
      end
    end
  end

  def register_ulab
    @ulab_results = Api::V2::UlabService.new(user_params).register_user

    if (@ulab_results[:status_code].blank? or @ulab_results[:status_code].to_i != 200)
      return false
    end

    return true
  end

  def user_params
    user_profile_params.merge({ email: @resource[:email], social: @resource[:provider], uid: @resource[:uid] });
  end

  def user_profile_params
    full_params = {}.merge(@profile)
    unless (@profile[:picture].blank?)
      decoded_picture = Base64ImageHelper.decode_picture(@profile[:picture])
      full_params = full_params.merge({ picture_name: decoded_picture.original_filename })
    end

    full_params
  end

  def render_login_success
    # Call ulab service to get braintree token if available
    params = { :login_token => @resource.ulab_access_token }
    ulab_results = Api::V2::UlabService.new(params).login_user
    user_data = resource_data(resource_json: @resource.token_validation_response)

    if (ulab_results[:status_code].blank? or ulab_results[:status_code].to_i != 200)
      user_data = user_data.merge({ customer_braintree_id: '' })
    else
      if ulab_results[:customer_braintree_id].nil?
        user_data = user_data.merge({ customer_braintree_id: '' })
      else
        user_data = user_data.merge({ customer_braintree_id: ulab_results[:customer_braintree_id] })
      end
    end

    render json: {
        status: 'success',
        data: user_data
    }
  end

  def render_login_failed
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

  def create_tokens_and_sign_in
    create_auth_tokens
    sign_in(:user, @resource, store: false, bypass: true)
    add_auth_params_to_response_headers
  end

  def create_auth_tokens
    create_token_info
    set_token_on_resource
    create_auth_params
  end

  def add_auth_params_to_response_headers
    @auth_params[:expiry] = @auth_params[:expiry].to_s
    @auth_params.delete(:config)
    @auth_params.stringify_keys!
    response.headers.merge!(@auth_params)
  end
end

class Api::V1::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  attr_reader :auth_params
  skip_before_action :set_user_by_token, raise: false
  skip_after_action :update_auth_header

  def fb_login
    @fb_user_data = Api::V1::FbGraphUserDataFetcherService.new(params[:fb_token]).call

    set_resource
    create_tokens_and_sign_in

    if @resource.save
      render json: {data: UserSerializer.new(@resource).results}
    else
      render json: {message: "Failed to save resource"}, status: 422
    end
  rescue Koala::Facebook::AuthenticationError => e
    render json: {errors: ['Invalid login credentials. Please try again.']}, status: 401
  end

  protected

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

  def assign_provider_attrs(user, auth_hash)
    user.assign_attributes({
      email: auth_hash['info']['email']
    })
  end

  private

  def set_resource
    @resource = User.where( uid: @fb_user_data['id'],
                            provider: :facebook,
                            email: @fb_user_data['email'] ).first_or_initialize

    if @resource.new_record?
      set_random_password

      @resource.save

      user_profile_h = {
        name: @fb_user_data['first_name'],
        surname: @fb_user_data['last_name'],
        picture: @fb_user_data['encoded_image']
      }

      form = Api::V1::UpdateUserProfileForm.new(user_profile_h)
      s = Api::V1::UpdateUserProfileService.new(@resource, form)
      s.call
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

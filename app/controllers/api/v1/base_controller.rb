class Api::V1::BaseController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  devise_token_auth_group :user, contains: [:api_v1_user, :api_v2_user]

  before_action :set_user

  private
  def not_found
    render json: {}
  end

  def resource_name
    :api_v1_user
  end

  def set_user
    set_user_by_token(resource_name)
  end

  def authenticate_if_token
    if @token.present?
      authenticate_api_v1_user!
    end
  end
end

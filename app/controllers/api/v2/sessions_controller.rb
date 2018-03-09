class Api::V2::SessionsController < DeviseTokenAuth::SessionsController
  def render_create_success
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

  def render_create_error_bad_credentials
    render json: {
        status: 'error',
        errors: [I18n.t("devise_token_auth.sessions.bad_credentials")]
    }, status: 401
  end
end

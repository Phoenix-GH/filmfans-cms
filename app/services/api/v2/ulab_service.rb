class Api::V2::UlabService
  def initialize(params={})
    @params = params
    initialize_request
  end

  def login_user
    response = @ulab_requests.user_login
    Rails.logger.info "Login ulab response with data: #{response.body}"
    @response_body = ActiveSupport::JSON.decode(response.body)

    login_results
  rescue StandardError => e
    Airbrake.notify(e)
    LogHelper.log_exception(e)
    false
  end

  def register_user
    response = @ulab_requests.user_register
    Rails.logger.info "Register ulab response with data: #{response.body}"
    @response_body = ActiveSupport::JSON.decode(response.body)

    register_results
  rescue StandardError => e
    Airbrake.notify(e)
    LogHelper.log_exception(e)
    false
  end

  def update_user
    response = @ulab_requests.user_update
    Rails.logger.info "Update ulab user profile response with data: #{response.body}"
    @response_body = ActiveSupport::JSON.decode(response.body)

    update_results
  rescue StandardError => e
    Airbrake.notify(e)
    LogHelper.log_exception(e)
    false
  end

  private
  def initialize_request
    @ulab_requests = UlabRequests.new(@params)
  end

  def login_results
    if @response_body['status_code'].to_i == 200
      {
          customer_braintree_id: @response_body['user']['customer_braintree_id']
      }.merge(request_results)
    else
      # add checking for user info to add it to devise
      request_results
    end
  end

  def register_results
    if @response_body['status_code'].to_i == 200
      {
        ulab_user_id: @response_body['user']['id'],
        ulab_access_token: @response_body['login_token']
      }.merge(request_results)
    else
      # add checking for user info to add it to devise
      request_results
    end
  end

  def update_results
    if @response_body['status_code'].to_i == 200
      {
          login_token: @response_body['login_token']
      }.merge(request_results)
    else
      request_results
    end
  end

  def request_results
    {
      message: @response_body['message'],
      status_code: @response_body['status_code']
    }
  end
end

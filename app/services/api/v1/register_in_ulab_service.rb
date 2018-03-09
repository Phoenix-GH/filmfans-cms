class Api::V1::RegisterInUlabService
  def initialize(params={})
    @params = params
  end

  def call
    initialize_ulab
    register_user

    ulab_params

  rescue StandardError => e
    Airbrake.notify(e)
    false
  end

  private
  def initialize_ulab
    @ulab_requests = UlabRequests.new(@params)
  end

  def register_user
    response = @ulab_requests.user_register

    @user_response_body = ActiveSupport::JSON.decode(response.body)
  end

  def ulab_params
    if @user_response_body['status_code'].to_i == 200
      {
        ulab_user_id: @user_response_body['user']['id'],
        ulab_access_token: @user_response_body['login_token']
      }
    elsif @user_response_body['status_code'].to_i == 500
      # add checking for user info to add it to devise
      {}
    else
      false
    end
  end
end

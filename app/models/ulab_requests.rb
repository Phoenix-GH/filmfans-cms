class UlabRequests
  def initialize(params={})
    @params = params
    oauth2
  end

  def oauth2
    url = URI("#{ENV['ULAB_API_URL']}/oauth2")
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url)
    request['accept'] = 'application/vnd.ulab.v0+json'
    request['content-type'] = 'application/json'
    request.body = {
      grant_type: 'client_credentials',
      client_id: ENV['ULAB_CLIENT_ID'],
      client_secret: ENV['ULAB_CLIENT_SECRET'],
      scope: 'mobile_access'
    }.to_json

    response = http.request(request)
    oauth2_response_body = ActiveSupport::JSON.decode(response.body)
    @token = oauth2_response_body['access_token']
  end

  def user_login
    url = URI("#{ENV['ULAB_API_URL']}/mobile/user_login")

    request = create_request(url)
    request.body = user_login_body.to_json

    http = Net::HTTP.new(url.host, url.port)

    http.request(request)
  end

  def user_register
    url = URI("#{ENV['ULAB_API_URL']}/mobile/user_register")

    request = create_request(url)
    request.body = user_register_body.to_json

    http = Net::HTTP.new(url.host, url.port)
    http.request(request)
  end

  def user_update
    url = URI("#{ENV['ULAB_API_URL']}/mobile/user_edit")

    request = create_request(url)
    request.body = profile_update_body.to_json

    http = Net::HTTP.new(url.host, url.port)
    http.request(request)
  end

  def crop
    url = URI("#{ENV['ULAB_API_URL']}/mobile/crop")

    request = create_request(url)
    request.body = crop_params.to_json

    http = Net::HTTP.new(url.host, url.port)

    http.request(request)
  end

  private

  def create_request(url)
    request = Net::HTTP::Post.new(url)
    request['accept'] = 'application/vnd.ulab.v0+json'
    request['authorization'] = "Bearer #{@token}"
    request['content-type'] = 'application/json'

    request
  end

  def user_login_body
    {
        login_token: @params[:login_token]
    }
  end

  def user_register_body
    request_body = {
        email: @params[:email]
    }

    if @params[:social]
      # register by social account
      request_body = request_body.merge({social: @params[:social]})
      request_body = request_body.merge({social_id: @params[:uid]})
    else
      # register by email
      request_body = request_body.merge({password: @params[:password]})
    end

    request_body.merge(user_profile_body)
  end

  def profile_update_body
    {
        login_token: @params[:login_token],
    }.merge(user_profile_body)
  end

  def user_profile_body
    user_profile_request_body = {}

    user_profile_request_body = user_profile_request_body.merge(:new_email => @params[:new_email]) unless @params[:new_email].blank?
    user_profile_request_body = user_profile_request_body.merge(:first_name => @params[:name]) if @params[:name]
    user_profile_request_body = user_profile_request_body.merge(:last_name => @params[:surname]) if @params[:surname]
    user_profile_request_body = user_profile_request_body.merge(:birthday => @params[:birthday]) if @params[:birthday]

    if @params[:picture]
      user_profile_request_body = user_profile_request_body.merge(:profile_img => @params[:picture])
      user_profile_request_body = user_profile_request_body.merge(:profile_img_name => @params[:picture_name])
    end

    if @params[:sex]
      if @params[:sex].blank?
        user_profile_request_body = user_profile_request_body.merge(:sex => 'NA')
      else
        sex = @params[:sex].downcase
        sex[0] = sex[0].capitalize
        user_profile_request_body = user_profile_request_body.merge(:sex => sex)
      end
    end

    user_profile_request_body
  end

  def crop_params
    @params
  end
end

describe 'Sessions requests' do
  context '/api/v1/auth/sign_in' do
    it 'success' do
      profile = create :profile, name: 'name', surname: 'surname'
      user = create(:user, ulab_user_id: '1234', ulab_access_token: '4321', profile: profile)
      address = create :address, label: 'home', user: user

      post '/api/v1/auth/sign_in', { email: user.email, password: user.password }
      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['uid']).to eq(user.email)
      expect(response.header['client'].present?).to eq(true)
      expect(response.header['access-token'].present?).to eq(true)
      expect(body['data']['ulab_user_id']).to eq('1234')
      expect(body['data']['ulab_access_token']).to eq('4321')
      expect(body['data']['email']).to eq(user.email)
      expect(body['data']['name']).to eq('name')
      expect(body['data']['surname']).to eq('surname')
      expect(body['data']['addresses'][0]['label']).to eq('home')
    end

    it 'error' do
      user = create(:user)

      post '/api/v1/auth/sign_in', { email: user.email, password: 'wrong_password' }
      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['access-token'].present?).to eq(false)
      expect(body['errors']).to eq(['Invalid login credentials. Please try again.'])
    end
  end

  context '/api/v1/users/exist' do
    it 'success' do
      user = create(:user)

      get '/api/v1/users/exist', { email: user.email }

      expect(body['success']).to eq('success')
    end

    it 'error' do
      get '/api/v1/users/exist', { email: 'aaa@o2.pl' }

      expect(body['errors']).to eq('errors')
    end
  end

  context '/api/v1/auth/sign_out' do
    it 'success' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      delete '/api/v1/auth/sign_out', { }, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body).to eq({"success"=>true})
    end

    it 'error' do
      create(:user)

      delete '/api/v1/auth/sign_out', {}, {}
      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['access-token'].present?).to eq(false)
      expect(body['errors']).to eq(['User was not found or was not logged in.'])
    end
  end

  context '/api/v1/fb_login/:token' do
    it 'success' do
      test_users = Koala::Facebook::TestUsers.new(app_id: ENV['FACEBOOK_KEY'],
                                                  secret: ENV['FACEBOOK_SECRET'])
      access_token = test_users.list.last['access_token']

      get "/api/v1/fb_login/#{access_token}"

      expect(response.header['access-token'].present?).to eq(true)
      expect(response.header['uid']).to eq(test_users.list.last['id'])
      expect(response.header['client'].present?).to eq(true)
    end

    it 'error' do
      wrong_access_token = 'xxx'
      get "/api/v1/fb_login/#{wrong_access_token}"

      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['access-token'].present?).to eq(false)
      expect(body['errors']).to eq(['Invalid login credentials. Please try again.'])
    end
  end

  context '/api/v1/auth/facebook?auth_origin_url=return_url' do
    before do
      host! 'localhost'
      OmniAuth.config.test_mode = true
    end

    it 'success' do
      OmniAuth.config.add_mock(:facebook,
             { :provider => 'facebook',
               :uid => '123456789zxcasdqwe'
             }
      )
      get_via_redirect '/api/v1/auth/facebook', auth_origin_url: 'http://localhost/api/v1/snapped_products'

      expect(response.header['access-token'].present?).to eq(true)
      expect(response.header['uid']).to eq('123456789zxcasdqwe')
      expect(response.header['client'].present?).to eq(true)
    end

    it 'error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      get_via_redirect '/api/v1/auth/facebook', auth_origin_url: 'http://localhost/api/v1/snapped_products'
      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['access-token'].present?).to eq(false)
      expect(body['errors']).to eq(["Use POST /sign_in to sign in. GET is not supported."])
    end
  end
end

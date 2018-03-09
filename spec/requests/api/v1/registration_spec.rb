describe 'Registration requests' do
  context '/api/v1/auth' do
    it 'sign_up: success' do
      params = {
        email: 'sample@gmail.com',
        password: 'secret',
        password_confirmation: 'secret',
        confirm_success_url: 'sample_url'
      }

      allow_any_instance_of(Api::V1::RegisterInUlabService)
      .to receive(:call)
      .and_return(
        {
          ulab_user_id: "1234",
          ulab_access_token: "4321"
        }
      )

      post '/api/v1/auth', params
      body = ActiveSupport::JSON.decode(response.body)
      expect(body['status']).to eq('success')
      user = User.find_by(email: 'sample@gmail.com')
      expect(user.present?).to eq true
      expect(user.ulab_user_id).to eq('1234')
      expect(user.ulab_access_token).to eq('4321')

      # registrations together with session creations:
      # welcome email is sent and auth headers are returned
      email = ActionMailer::Base.deliveries.last
      expect(email).to have_subject 'Welcome to HotSpotting'

      expect(response.header['uid']).to eq(user.email)
      expect(response.header['client'].present?).to eq(true)
      expect(response.header['access-token'].present?).to eq(true)

      # user is able to log in again without confirmation
      post '/api/v1/auth/sign_in', { email: user.email, password: 'secret' }
      body = ActiveSupport::JSON.decode(response.body)

      expect(response.header['uid']).to eq(user.email)
      expect(response.header['client'].present?).to eq(true)
      expect(response.header['access-token'].present?).to eq(true)
    end

    it 'sign_up: ulab error' do
      params = {
        email: 'sample@gmail.com',
        password: 'secret',
        password_confirmation: 'secret',
        confirm_success_url: 'sample_url'
      }

      allow_any_instance_of(Api::V1::RegisterInUlabService)
      .to receive(:call)
      .and_return(false)

      post '/api/v1/auth', params
      body = ActiveSupport::JSON.decode(response.body)
      expect(body['status']).to eq('error')
      user = User.find_by(email: 'sample@gmail.com')
      expect(user.present?).to eq false
    end

    it 'sign_up: devise error' do
      params = {
        email: 'sample@gmail.com',
        password: 'secret123',
        password_confirmation: 'aaaa',
        confirm_success_url: 'sample_url'
      }

      post '/api/v1/auth', params
      body = ActiveSupport::JSON.decode(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['full_messages']).to eq(
        ["Password confirmation doesn't match Password"]
      )
      expect(User.find_by(email: 'sample@gmail.com').present?).to eq false
    end

    it 'update password success' do
      user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      put '/api/v1/auth', {
        password: 'sample',
        password_confirmation: 'sample',
        current_password: user.password
      }, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['status']).to eq('success')
    end

    it 'update password error' do
      user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      put '/api/v1/auth', {  password: 'sample', password_confirmation: 'wrongconf' }, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']['full_messages']).to eq(
        ["Password confirmation doesn't match Password", "Current password can't be blank"]
      )
    end
  end

  context 'post /api/v1/auth/password RESEND CONFIRMATION EMAIL' do
    it 'success' do
      user = create(:user)

      post '/api/v1/auth/password', { email: user.email, redirect_url: 'sample_url' }
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['success']).to eq(true)
    end

    it 'error' do
      post '/api/v1/auth/password', { email: 'wrong_email@o2.pl', redirect_url: 'sample_url' }
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']).to eq(["Unable to find user with email 'wrong_email@o2.pl'."])
    end
  end

  context 'put /api/v1/auth/password UPDATE PASSWORD' do
    it 'success' do
      user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      allow(user).to receive(:allow_password_change).and_return(true)

      put '/api/v1/auth/password', {
        password: 'sample',
        password_confirmation: 'sample'
      }, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['success']).to eq(true)
      expect(body['message']).to eq('Your password has been successfully updated.')
      expect(body['data']['email']).to eq(user.email)
    end

    it 'error' do
      user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      put '/api/v1/auth/password', {  password: 'sample', password_confirmation: 'wrongconf' }, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']['full_messages']).to eq(
        ["Password confirmation doesn't match Password"]
      )
    end
  end
end

describe Api::V1::RegisterInUlabService do
  it 'call' do
    user_params = {
      email: 'sample@sample.pl',
      password: 'password'
    }

    service = Api::V1::RegisterInUlabService.new(user_params)
    ouath_response = double(
      'ouath_response',
      body: {
        "access_token": "jpfvhQjuutsYHSo9T4RGsS86gha5NpkWjgXWdw1m",
        "token_type": "Bearer",
        "expires_in": 7200,
        "status_code": 200
      }.to_json
    )
    user_response = double(
      'user_response',
      body: {
        "message": "Register successfully",
        "user": {
          "id": "301",
          "email": "sample@sample.pl",
        },
        "login_token": "abc",
        "status_code": "200"
      }.to_json
    )

    allow_any_instance_of(UlabRequests).to receive(:oauth2).and_return(ouath_response)
    allow_any_instance_of(UlabRequests).to receive(:user_register).and_return(user_response)

    expect(service.call).to eq(
      {
        ulab_user_id: "301",
        ulab_access_token: "abc"
      }
    )
  end

  context 'access token invalid or expired' do
    it 'returns false' do
      user_params = {
        email: 'sample@sample.pl',
        password: 'password'
      }

      service = Api::V1::RegisterInUlabService.new(user_params)

      ouath_response = double(
        'ouath_response',
        body: {
          "status_code": 401
        }.to_json
      )
      allow_any_instance_of(UlabRequests).to receive(:oauth2).and_return(ouath_response)

      expect(service.call).to eq false
    end
  end

  context 'user already exists' do
    it 'returns {}' do
      user_params = {
        email: 'sample@sample.pl',
        password: 'password'
      }

      ouath_response = double(
        'ouath_response',
        body: {
          "access_token": "jpfvhQjuutsYHSo9T4RGsS86gha5NpkWjgXWdw1m",
          "token_type": "Bearer",
          "expires_in": 7200,
          "status_code": 200
        }.to_json
      )
      user_response = double(
        'user_response',
        body: {
          "message": "This user already exists",
          "status_code": "500"
        }.to_json
      )

      allow_any_instance_of(UlabRequests).to receive(:oauth2).and_return(ouath_response)
      allow_any_instance_of(UlabRequests).to receive(:user_register).and_return(user_response)

      service = Api::V1::RegisterInUlabService.new(user_params)

      expect(service.call).to eq({})
    end
  end

  context 'no response from ulab' do
    it 'returns false' do
      user_params = {
        email: 'sample@sample.pl',
        password: 'password'
      }

      allow_any_instance_of(UlabRequests).to receive(:oauth2).and_raise(StandardError)

      service = Api::V1::RegisterInUlabService.new(user_params)

      expect(service.call).to eq(false)
    end
  end
end

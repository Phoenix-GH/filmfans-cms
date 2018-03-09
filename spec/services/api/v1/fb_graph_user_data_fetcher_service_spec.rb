describe Api::V1::FbGraphUserDataFetcherService do
  before do
    @test_users = Koala::Facebook::TestUsers.new(app_id: ENV['FACEBOOK_KEY'],
                                                 secret: ENV['FACEBOOK_SECRET'])
  end

  it 'call' do
    fb_user_h = @test_users.list.last
    access_token = fb_user_h['access_token']

    fb_fetched_data = Api::V1::FbGraphUserDataFetcherService.new(access_token).call

    expect(fb_fetched_data).to have_key('id')
    expect(fb_fetched_data['id']).to eq(fb_user_h['id'])
    expect(fb_fetched_data).to have_key('first_name')
    expect(fb_fetched_data).to have_key('last_name')
  end

  context 'access_token invalid' do
    it 'throws exception' do 
      invalid_access_token = 'invalid access token'
      service = Api::V1::FbGraphUserDataFetcherService.new(invalid_access_token)

      expect { service.call }.to raise_error(Koala::Facebook::AuthenticationError)
    end
  end
end

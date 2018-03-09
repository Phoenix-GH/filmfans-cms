describe 'Snapped products requests' do
  it '/api/v1/snapped_photos/' do
    user = create(:user)
    user_auth_header = user.create_new_auth_token(user.tokens.keys[0])

    photo1 = create(:snapped_photo, user: user)
    photo2 = create(:snapped_photo, user: user)

    get '/api/v1/snapped_photos/', {}, user_auth_header
    body = ActiveSupport::JSON.decode(response.body)

    expect(body.map { |h| h['image'] }).to eq([photo1.image.url, photo2.image.url])
  end

  context 'guest user' do
    it '/api/v1/snapped_photos/' do
      get '/api/v1/snapped_photos/', {}
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']).to eq(['Authorized users only.'])
    end
  end

  it '/api/v1/snapped_photos/' do
    params = {
      image: File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt"),
    }
    user = create(:user)
    user_auth_header = user.create_new_auth_token(user.tokens.keys[0])

    expect(SaveSnappedPhotoWorker).to receive(:perform_async)

    post '/api/v1/snapped_photos', params, user_auth_header
    expect(response.status).to eq 200
  end
end

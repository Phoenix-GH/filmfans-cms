describe 'Address requests' do
  context '/api/v1/addresses' do
    it '/api/v1/addresses' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      create :address, user: user, city: 'New York'
      create :address, user: user, city: 'London'
      create :address

      get '/api/v1/addresses', {}, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)
      results = body.map { |h| h['city'] }
      expect(results).to eq(['New York', 'London'])
    end

    it '/api/v1/addresses/#create' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      post '/api/v1/addresses', {
          label: 'label',
          city: 'city',
          street: 'street 123',
          zip_code: '01-222',
          country: 'Poland',
          primary: '1'
        }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['label']).to eq('label')
      expect(body['city']).to eq('city')
      expect(body['user_id']).to eq(user.id)
    end

    it '/api/v1/addresses/#create error' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      post '/api/v1/addresses', {
          label: '',
          city: 'Warsaw',
          street: '',
          zip_code: '01-222',
          country: ''
        }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body).to eq(["Street can't be blank", "Country can't be blank", "Primary can't be blank"])
    end

    it '/api/v1/addresses/#update' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      address = create :address, user_id: user.id
      put "/api/v1/addresses/#{address.id}", {
          label: 'home',
          city: 'Warsaw',
          zip_code: '01-222',
          primary: '1'
        }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['zip_code']).to eq('01-222')
      expect(body['country']).to eq(address.country)
    end

    it '/api/v1/addresses/#destroy' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
      address = create :address, user_id: user.id
      create :address, user_id: user.id
      expect(user.addresses.count).to eq 2
      delete "/api/v1/addresses/#{address.id}", {}, new_auth_header

      expect(response.status).to eq 200
      expect(user.addresses.count).to eq 1
    end
  end
end

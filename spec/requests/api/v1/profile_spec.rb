describe 'Profile requests' do
  context '/api/v1/user_profile/update' do
    it 'update user profile: success' do
      user = create(:user, :with_token)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      put '/api/v1/user_profile/update', {
        name: 'sample',
        surname: 'surname',
        picture: Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
      }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)

      expect(body['status']).to eq('success')
      expect(body['data']['name']).to eq('sample')
      expect(body['data']['surname']).to eq('surname')
      expect(user.profile.reload.name).to eq 'sample'
      expect(user.profile.reload.surname).to eq 'surname'
      expect(user.profile.reload.picture).to be_present
    end

    it 'update user name and surname: success' do
      user = create(:user, :with_token, :with_profile_with_picture)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      put '/api/v1/user_profile/update', {
        name: 'sample',
        surname: 'surname'
      }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)

      expect(body['status']).to eq('success')
      expect(user.profile.reload.name).to eq 'sample'
      expect(user.profile.reload.surname).to eq 'surname'
    end

    it 'update user profile: delete profile picture' do
      user = create(:user, :with_token, :with_profile_with_picture)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      put '/api/v1/user_profile/update', {
        name: user.profile.name,
        surname: user.profile.surname,
        picture: ''
      }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)

      expect(body['status']).to eq('success')
      expect(user.profile.reload.name).to be_present
      expect(user.profile.reload.surname).to be_present
      expect(user.profile.reload.picture).to be_present
    end

    it 'update user profile: error' do
      user = create(:user, :with_token, :with_profile_with_picture)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      put '/api/v1/user_profile/update', {
        name: '',
        surname: '',
        picture: ''
      }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['full_messages']).to eq(["Name can't be blank", "Surname can't be blank"])
      expect(user.profile.reload.name).to be_present
      expect(user.profile.reload.surname).to be_present
      expect(user.profile.reload.picture).to be_present
    end
  end
end

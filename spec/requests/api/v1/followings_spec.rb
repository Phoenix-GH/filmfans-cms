describe 'Followings requests' do
  context '/api/v1/followings/toggle' do
    it 'follow mediaOwner' do
      user = create(:user)
      another_user = create(:user)
      fergie = create(:media_owner, name: 'Fergie')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:following, user: another_user, followed_id: fergie.id, followed_type: 'MediaOwner')

      post "/api/v1/followings/toggle",
        {followed_id: fergie.id, followed_type: 'MediaOwner'}, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['followers']).to eq(2)
      expect(user.media_owners.first).to eq(fergie)
    end

    it 'follow Channel' do
      user = create(:user)
      another_user = create(:user)
      fergie = create(:channel, name: 'Fergie')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:following, user: another_user, followed_id: fergie.id, followed_type: 'Channel')

      post "/api/v1/followings/toggle",
        {followed_id: fergie.id, followed_type: 'Channel'}, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['followers']).to eq(2)
      expect(user.channels.first).to eq(fergie)
    end

    it 'unfollow' do
      user = create(:user)
      another_user = create(:user)
      fergie = create(:media_owner, name: 'Fergie')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:following, user: user, followed_id: fergie.id, followed_type: 'MediaOwner')
      create(:following, user: another_user, followed_id: fergie.id, followed_type: 'MediaOwner')

      post "/api/v1/followings/toggle",
        {followed_id: fergie.id, followed_type: 'MediaOwner'}, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['isfollowing']).to eq(false)
      expect(body['followers']).to eq(1)
    end

    it 'invlid media_owner id' do
      user = create(:user)
      another_user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:following, user: user)
      create(:following, user: another_user)

      post "/api/v1/followings/toggle",
        {followed_id: 5, followed_type: 'MediaOwner'}, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body).to eq(['Media owner not found.'])
    end
  end

end

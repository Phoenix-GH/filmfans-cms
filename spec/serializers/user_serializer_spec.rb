describe UserSerializer do
  it 'return' do
    user = create(:user, :with_profile_with_picture)
    results = UserSerializer.new(user).results

    expect(results).to eq(
      {
        id: user.id,
        provider: user.provider,
        uid: user.uid,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at,
        ulab_user_id: user.ulab_user_id,
        ulab_access_token: user.ulab_access_token,
        name: user.profile.name,
        surname: user.profile.surname,
        picture: user.profile.picture.url
      }
    )
  end

  it 'without profile' do
    user = create(:user)
    results = UserSerializer.new(user).results

    expect(results).to eq(
      {
        id: user.id,
        provider: user.provider,
        uid: user.uid,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at,
        ulab_user_id: user.ulab_user_id,
        ulab_access_token: user.ulab_access_token
      }
    )
  end
end

describe ProfileSerializer do
  it 'return' do
    profile = create(:profile, :with_profile_picture,  name: 'name', surname: 'surname')
    results = ProfileSerializer.new(profile).results

    expect(results).to eq(
        {
          name: 'name',
          surname: 'surname',
          picture: profile.picture.url
        }
      )
  end

  it 'missing values' do
    profile = create(:profile, name: 'name', surname: nil)
    results = ProfileSerializer.new(profile).results
    expect(results).to eq(
        {
          name: 'name',
          surname: '',
          picture: profile.picture.url
        }
      )
  end
end

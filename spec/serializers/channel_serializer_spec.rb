describe ChannelSerializer do
  it 'return' do
    channel = build(:channel, name: 'MTV')
    results = ChannelSerializer.new(channel).results

    expect(results).to eq(
      {
        id: channel.id,
        name: 'MTV',
        thumbnail_url: channel.picture.custom_url,
        image_url: channel.picture.custom_url,
        feed: true,
        magazines: false,
        tv_shows: false
      }
    )
  end

  it 'return with followed_flag' do
    channel = create(:channel, name: 'MTV')
    user = create :user
    create(:following, user: user, followed_type: 'Channel', followed_id: channel.id )
    results = ChannelSerializer.new(channel, user).results

    expect(results).to eq(
        {
          id: channel.id,
          name: 'MTV',
          thumbnail_url: channel.picture.custom_url,
          image_url: channel.picture.custom_url,
          feed: true,
          magazines: false,
          tv_shows: false,
          is_followed: true
        }
      )
  end

  it 'missing values' do
    channel = build(:channel, name: nil, picture: nil)
    results = ChannelSerializer.new(channel).results
    expect(results).to eq(
      {
        id: channel.id,
        name: '',
        thumbnail_url: '',
        image_url: '',
        feed: true,
        magazines: false,
        tv_shows: false
      }
    )
  end
end

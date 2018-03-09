describe MediaOwnerSerializer do
  it 'return' do
    media_owner = create(:media_owner, name: 'Jessica Alba', url: 'superUrl')
    channel = create(:channel, name: 'Channel')
    create(:channel_media_owner, channel_id: channel.id, media_owner_id: media_owner.id)
    results = MediaOwnerSerializer.new(media_owner, true).results

    expect(results).to eq(
      {
        id: media_owner.id,
        name: 'Jessica Alba',
        thumbnail_url: media_owner.picture.custom_url,
        image_url: media_owner.picture.custom_url,
        url: 'superUrl',
        background_image_url: media_owner.background_image.custom_url,
        channels: [ChannelSerializer.new(channel).results],
        feed: true
      }
    )
  end

  it 'return with followed_flag' do
    media_owner = create(:media_owner, name: 'Jessica Alba', url: 'superUrl')
    channel = create(:channel, name: 'Channel')
    create(:channel_media_owner, channel_id: channel.id, media_owner_id: media_owner.id)
    user = create :user
    create(:following, user: user, followed_type: 'MediaOwner', followed_id: media_owner.id )
    results = MediaOwnerSerializer.new(media_owner, true, user).results

    expect(results).to eq(
        {
          id: media_owner.id,
          name: 'Jessica Alba',
          thumbnail_url: media_owner.picture.custom_url,
          image_url: media_owner.picture.custom_url,
          url: 'superUrl',
          background_image_url: media_owner.background_image.custom_url,
          channels: [ChannelSerializer.new(channel).results],
          feed: true,
          is_followed: true
        }
      )
  end

  it 'missing values' do
    media_owner = build(:media_owner, name: nil, picture: nil, background_image: nil)
    results = MediaOwnerSerializer.new(media_owner).results
    expect(results).to eq(
      {
        id: media_owner.id,
        name: '',
        thumbnail_url: ''
      }
    )
  end
end

describe OwnerSerializer do
  it 'return media owner' do
    media_owner = create(:media_owner)
    results = OwnerSerializer.new(media_owner).results

    expect(results).to eq(
      {
        id: media_owner.id,
        type: 'media_owner',
        name: media_owner.name,
        thumbnail_url: media_owner.picture.custom_url
      }
    )
  end

  it 'return channel' do
    channel = create(:channel)
    results = OwnerSerializer.new(channel).results

    expect(results).to eq(
      {
        id: channel.id,
        type: 'channel',
        name: channel.name,
        thumbnail_url: channel.picture.custom_url
      }
    )
  end
end
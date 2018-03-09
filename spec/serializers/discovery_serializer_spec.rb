describe DiscoverySerializer do
  it 'return for media owners' do
    media_owner1 = create(:media_owner)
    media_owner2 = create(:media_owner)
    source1 = create(:facebook_source, source_owner: media_owner1)
    source2 = create(:twitter_source, source_owner: media_owner2)
    create(:video_post, source: source1)
    create(:image_post, source: source1)
    create(:video_post, source: source2)
    create(:image_post, source: source2)
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = DiscoverySerializer.new(MediaOwner, params).results

    expect(results[:social_media_containers].length).to eq(4)
  end

  it 'return for channels' do
    channel1 = create(:channel)
    channel2 = create(:channel)
    source1 = create(:facebook_source, source_owner: channel1)
    source2 = create(:twitter_source, source_owner: channel2)
    create(:video_post, source: source1)
    create(:image_post, source: source1)
    create(:video_post, source: source2)
    create(:image_post, source: source2)
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = DiscoverySerializer.new(Channel, params).results

    expect(results[:social_media_containers].length).to eq(4)
  end

  it 'return for channels with media owners' do
    media_owner = create(:media_owner)
    channel1 = create(:channel, media_owners: [media_owner])
    channel2 = create(:channel)
    source1 = create(:facebook_source, source_owner: channel1)
    source2 = create(:twitter_source, source_owner: channel2)
    source3 = create(:instagram_source, source_owner: media_owner)
    create(:video_post, source: source1)
    create(:image_post, source: source1)
    create(:video_post, source: source2)
    create(:image_post, source: source2)
    create(:video_post, source: source3)
    create(:image_post, source: source3)
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = DiscoverySerializer.new(Channel, params).results

    expect(results[:social_media_containers].length).to eq(6)
  end
end
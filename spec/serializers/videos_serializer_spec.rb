describe VideosSerializer do
  it 'return videos only' do
    media_owner = create(:media_owner)
    source = create(:facebook_source, source_owner: media_owner)
    create(:image_post, source: source)
    2.times { create(:video_post, source: source) }
    2.times { create(:media_container, :with_video, owner: media_owner) }
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = VideosSerializer.new(media_owner, params).results

    expect(results[:social_media_containers].length).to eq(2)
    expect(results[:media_containers].length).to eq(2)
  end

  it 'return only cms videos if social media feed is not active' do
    media_owner = create(:media_owner, feed_active: false)
    source = create(:facebook_source, source_owner: media_owner)
    3.times { create(:video_post, source: source) }
    3.times { create(:media_container, :with_video, owner: media_owner) }
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = VideosSerializer.new(media_owner, params).results

    expect(results[:social_media_containers]).to eq([])
    expect(results[:media_containers].length).to eq(3)
  end

  it 'return only visible videos' do
    media_owner = create(:media_owner)
    source = create(:facebook_source, source_owner: media_owner)
    hidden_post = create(:video_post, source: source, visible: false)
    2.times { create(:video_post, source: source) }
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = VideosSerializer.new(media_owner, params).results

    expect(results[:social_media_containers].length).to eq(2)
    expect(results[:social_media_containers][0][:id]).not_to eq(hidden_post.id)
    expect(results[:social_media_containers][1][:id]).not_to eq(hidden_post.id)
  end


  it 'return videos from channel media owners' do
    media_owner = create(:media_owner)
    channel = create(:channel, media_owners: [media_owner])
    source1 = create(:facebook_source, source_owner: media_owner)
    source2 = create(:facebook_source, source_owner: channel)
    create(:video_post, source: source1)
    create(:video_post, source: source2)
    create(:media_container, :with_video, owner: media_owner)
    create(:media_container, :with_video, owner: channel)
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = VideosSerializer.new(channel, params).results

    expect(results[:social_media_containers].length).to eq(2)
    expect(results[:media_containers].length).to eq(2)
  end
end
describe SocialFeedSerializer do
  it 'return only until timestamp' do
    media_owner = create(:media_owner)
    source = create(:facebook_source, source_owner: media_owner)
    post1 = create(:image_post, source: source, published_at: Time.now - 3.days)
    post2 = create(:image_post, source: source, published_at: Time.now - 4.days)
    create(:image_post, source: source, published_at: Time.now)
    params = { number_of_posts: 10, timestamp: post1.published_at.to_i + 1 }
    results = SocialFeedSerializer.new(media_owner, params).results

    expect(results[:social_media_containers].length).to eq(2)
    expect(results[:social_media_containers][0][:id]).to eq(post1.id)
    expect(results[:social_media_containers][1][:id]).to eq(post2.id)
  end

  it 'return nothing if social media feed is not active' do
    media_owner = create(:media_owner, feed_active: false)
    source = create(:facebook_source, source_owner: media_owner)
    3.times { create(:image_post, source: source) }
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = SocialFeedSerializer.new(media_owner, params).results

    expect(results[:social_media_containers]).to eq([])
  end

  it 'return only visible posts' do
    media_owner = create(:media_owner)
    source = create(:facebook_source, source_owner: media_owner)
    hidden_post = create(:image_post, source: source, visible: false)
    2.times { create(:image_post, source: source) }
    params = { number_of_posts: 10, timestamp: Time.now.to_i }
    results = SocialFeedSerializer.new(media_owner, params).results

    expect(results[:social_media_containers].length).to eq(2)
    expect(results[:social_media_containers][0][:id]).not_to eq(hidden_post.id)
    expect(results[:social_media_containers][1][:id]).not_to eq(hidden_post.id)
  end


  context 'Channel with media owners' do
    it 'return posts from channel media owners' do
      media_owner = create(:media_owner)
      channel = create(:channel, media_owners: [media_owner])
      source1 = create(:facebook_source, source_owner: media_owner)
      source2 = create(:facebook_source, source_owner: channel)
      2.times { create(:image_post, source: source1) }
      2.times { create(:image_post, source: source2) }
      params = { number_of_posts: 10, timestamp: Time.now.to_i }
      results = SocialFeedSerializer.new(channel, params).results

      expect(results[:social_media_containers].length).to eq(4)
    end

    it 'do not return posts from media owner with inactive social media feed' do
      media_owner = create(:media_owner, feed_active: false)
      channel = create(:channel, media_owners: [media_owner])
      source1 = create(:facebook_source, source_owner: media_owner)
      source2 = create(:facebook_source, source_owner: channel)
      2.times { create(:image_post, source: source1) }
      2.times { create(:image_post, source: source2) }
      params = { number_of_posts: 10, timestamp: Time.now.to_i }
      results = SocialFeedSerializer.new(channel, params).results

      expect(results[:social_media_containers].length).to eq(2)
    end
  end
end
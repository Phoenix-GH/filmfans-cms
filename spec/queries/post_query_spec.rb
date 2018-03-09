describe PostQuery do
  context 'source owner type' do
    it 'media owner' do
      media_owner = create(:media_owner)
      facebook = create(:facebook_source, source_owner: media_owner)
      image1 = create(:image_post, source: facebook)
      image2 = create(:image_post, source: facebook)
      video = create(:video_post, source: facebook)
      
      ids = PostQuery.new(media_owner).results.map(&:id)
      expect(ids).to include(image1.id)
      expect(ids).to include(image2.id)
      expect(ids).to include(video.id)
    end

    it 'channel' do
      media_owner = create(:media_owner)
      channel = create(:channel, media_owners: [media_owner])
      facebook = create(:facebook_source, source_owner: channel)
      facebook_image = create(:image_post, source: facebook)
      facebook_video = create(:video_post, source: facebook)
      instagram = create(:instagram_source, source_owner: media_owner)
      instagram_image = create(:image_post, source: instagram)
      instagram_video = create(:video_post, source: instagram)
      
      ids = PostQuery.new(channel).results.map(&:id)
      expect(ids).to include(facebook_image.id)
      expect(ids).to include(facebook_video.id)
      expect(ids).to include(instagram_image.id)
      expect(ids).to include(instagram_video.id)
    end
  end

  context 'order' do
    it 'by published_at descending' do
      media_owner = create(:media_owner)
      facebook = create(:facebook_source, source_owner: media_owner)
      image = create(:image_post, source: facebook, published_at: DateTime.now - 3)
      video = create(:video_post, source: facebook, published_at: DateTime.now - 1)
      
      results = PostQuery.new(media_owner).results
      expect(results.map(&:id)).to eq([video.id, image.id])
    end
  end

  context 'filter' do
    it 'by source_id' do
      media_owner = create(:media_owner)
      facebook = create(:facebook_source, source_owner: media_owner)
      2.times { create(:image_post, source: facebook) }
      twitter = create(:twitter_source, source_owner: media_owner)
      twitter_image = create(:image_post, source: twitter)

      results = PostQuery.new(media_owner, {source_id: facebook.id}).results
      expect(results.length).to eq(2)
      expect(results.map(&:id)).not_to include(twitter_image.id)
    end
  end
end

describe LinkSerializer do
  context 'media_owner' do
    it 'return' do
      link = create :link,
      target: build(
        :media_owner,
        name: 'Celebrity Name',
        url: 'www.celebrity.com'
      )

      results = LinkSerializer.new(link).results
      expect(results).to eq(
        {
          id: link.id,
          target_id: link.target.id,
          name: 'Celebrity Name',
          type: 'link_container',
          link_type: 'media_owner',
          number_of_videos: 0,
          description: '',
          image_url: link.target.picture.custom_url
        }
      )
    end
  end

  context 'channel' do
    it 'return' do
      link = create :link,
      target: create(
        :channel,
        :with_video_container,
        name: 'Channel Name'
      )

      results = LinkSerializer.new(link).results
      expect(results).to eq(
        {
          id: link.id,
          target_id: link.target.id,
          name: 'Channel Name',
          type: 'link_container',
          link_type: 'channel',
          number_of_videos: 1,
          description: '',
          image_url: link.target.picture.custom_url
        }
      )
    end
  end

  context 'magazine' do
    it 'return' do
      link = create :link,
      target: create(
        :magazine,
        :with_cover_image,
        title: 'Magazine title',
        description: 'Magazine description'
      )

      results = LinkSerializer.new(link).results
      expect(results).to eq(
        {
          id: link.id,
          target_id: link.target.id,
          name: 'Magazine title',
          type: 'link_container',
          link_type: 'magazine',
          number_of_videos: 0,
          description: 'Magazine description',
          image_url: link.target.cover_image.custom_url,
          number_of_issues: 0
        }
      )
    end
  end

  context 'tv show' do
    it 'return' do
      link = create :link,
      target: create(
        :tv_show,
        :with_cover_image,
        :with_1_season_2_episodes,
        title: 'Tv Show title',
        description: 'Tv Show description'
      )

      results = LinkSerializer.new(link).results
      expect(results).to eq(
        {
          id: link.id,
          target_id: link.target.id,
          name: 'Tv Show title',
          type: 'link_container',
          link_type: 'tv_show',
          number_of_videos: 2,
          description: 'Tv Show description',
          image_url: link.target.cover_image.custom_url
        }
      )
    end
  end

  context 'event' do
    it 'return' do
      link = create :link,
      target: create(
        :event,
        :with_cover_image,
        name: 'Event Super Name'
      )

      results = LinkSerializer.new(link).results
      expect(results).to eq(
        {
          id: link.id,
          target_id: link.target.id,
          name: 'Event Super Name',
          type: 'link_container',
          link_type: 'event',
          number_of_videos: 0,
          description: '',
          image_url: link.target.cover_image.custom_url
        }
      )
    end
  end
end

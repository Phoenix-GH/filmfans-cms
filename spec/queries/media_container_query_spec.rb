describe MediaContainerQuery do
  context 'order' do
    it 'default by created_at ascending' do
      create :media_container, name: 'Yesterday', created_at: Date.yesterday
      create :media_container, name: 'Today', created_at: Date.today

      results = MediaContainerQuery.new.results
      expect(results.map(&:name)).to eq(['Yesterday', 'Today'])
    end
  end

  context 'filter' do
    it 'by created_at' do
      create :media_container, name: 'Yesterday', created_at: Date.yesterday
      create :media_container, name: 'Today', created_at: Date.today

      results = MediaContainerQuery.new({ last_date: Date.today }).results
      expect(results.map(&:name)).to eq(['Yesterday'])
    end

    it 'by media_owner' do
      owner = build_stubbed(:media_owner, name: 'Lopez')
      create :media_container, name: 'Lopez outfit', owner: owner
      create :media_container, name: 'Bella outfit'

      results = MediaContainerQuery.new({ media_owner_id: [owner.id] }).results
      expect(results.map(&:name)).to eq(['Lopez outfit'])
    end

    it 'by media_owner presence' do
      owner = build_stubbed(:media_owner, name: 'Lopez')
      create :media_container, name: 'Lopez outfit', owner: owner
      create :media_container, name: 'Bella outfit', owner: nil

      query = MediaContainerQuery.new({ with_media_owner: true })
      expect(query.results.map(&:name)).to eq(['Lopez outfit'])
    end

    it 'by channel' do
      channel = build_stubbed(:channel, name: 'MTV')
      create :media_container, name: 'MTV outfit', owner: channel
      create :media_container, name: 'other outfit'

      results = MediaContainerQuery.new({ channel_id: [channel.id] }).results
      expect(results.map(&:name)).to eq(['MTV outfit'])
    end

    it 'by channel presence' do
      channel = build_stubbed(:channel, name: 'MTV')
      create :media_container, name: 'MTV outfit', owner: channel
      create :media_container, name: 'other outfit', owner: nil

      query = MediaContainerQuery.new({ with_channel: true })
      expect(query.results.map(&:name)).to eq(['MTV outfit'])
    end

    it 'by ability filter channel' do
      channel = build_stubbed(:channel)
      create :media_container, name: 'Lopez outfit', owner: channel
      create :media_container, name: 'Bella outfit'

      results = MediaContainerQuery.new({ channel_ids: [channel.id] }).results
      expect(results.map(&:name)).to eq(['Lopez outfit'])
    end

    it 'by ability filter media_owner' do
      media_owner = build_stubbed(:media_owner)
      create :media_container, name: 'Lopez outfit', owner: media_owner
      create :media_container, name: 'Bella outfit'

      results = MediaContainerQuery.new({ media_owner_ids: [media_owner.id] }).results
      expect(results.map(&:name)).to eq(['Lopez outfit'])
    end

    it 'by file_type' do
      media_content = create :media_content, :with_file_type_image
      media_content2 = create :media_content, :with_file_type_video
      create :media_container, name: 'Lopez outfit', media_content: media_content
      create :media_container, name: 'Bella outfit', media_content: media_content2

      results = MediaContainerQuery.new({ media_content_type: 'image' }).results
      expect(results.map(&:name)).to eq(['Lopez outfit'])
    end
  end

  it 'search by name' do
    create :media_container, name: 'Yesterday', created_at: Date.yesterday
    create :media_container, name: 'Today', created_at: Date.today

    results = MediaContainerQuery.new({ search: 'yes' }).results
    expect(results.map(&:name)).to eq(['Yesterday'])
  end
end

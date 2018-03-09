describe MediaOwnerQuery do
  context 'order' do
    it 'by id ascending' do
      create :media_owner, name: 'First'
      create :media_owner, name: 'Second'

      results = MediaOwnerQuery.new.results
      expect(results.map(&:name)).to eq(['First', 'Second'])
    end

    it 'by followings' do
      owner1 = create :media_owner, name: 'Lopez'
      owner2 = create :media_owner, name: 'Fergie'
      owner3 = create :media_owner, name: 'Alba'
      channel = create :channel
      create(:following, followed_id: owner3.id, followed_type: 'MediaOwner')
      create(:following, followed_id: owner3.id, followed_type: 'MediaOwner')
      create(:following, followed_id: owner1.id, followed_type: 'MediaOwner')
      create(:following, followed_id: channel.id, followed_type: 'Channel')

      results = MediaOwnerQuery.new({ sort: 'followings' }).results
      expect(results.map(&:name)).to eq(['Alba', 'Lopez', 'Fergie'])
    end
  end

  it 'search by name' do
    create :media_owner, name: 'First'
    create :media_owner, name: 'Second'

    results = MediaOwnerQuery.new({ search: 'Fir' }).results
    expect(results.map(&:name)).to eq(['First'])
  end

  it 'filter by channel' do
    channel = create(:channel)
    channel2 = create(:channel)
    owner = create(:media_owner, name: 'with channel')
    owner2 = create(:media_owner, name: 'with channel2')
    other = create(:media_owner, name: 'with other channel')
    create(:media_owner, name: 'without channel')
    create(:channel_media_owner, media_owner: owner, channel: channel)
    create(:channel_media_owner, media_owner: owner2, channel: channel2)
    create(:channel_media_owner, media_owner: other, channel: create(:channel))

    results = MediaOwnerQuery.new({ channel_id: [channel.id, channel2] }).results
    expect(results.map(&:name)).to eq(['with channel', 'with channel2'])
  end

  it 'filter by media_owner_ids' do
    media_owner1 = create(:media_owner, name: 'Lopez')
    media_owner2 = create(:media_owner)

    results = MediaOwnerQuery.new({media_owner_ids: [media_owner1]}).results
    expect(results.map(&:name)).to eq(['Lopez'])
  end
end

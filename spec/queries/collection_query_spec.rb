describe CollectionQuery do
  context 'order' do
    it 'by created_at ascending' do
      collection = create(:collection, created_at: DateTime.now)
      collection2 = create(:collection, created_at: DateTime.now - 1.days)

      results = CollectionQuery.new.results
      expect(results).to eq([collection2, collection])
    end
  end

  it 'search by name' do
    create :collection, name: 'First'
    create :collection, name: 'Second'

    results = CollectionQuery.new({ search: 'fir' }).results
    expect(results.map(&:name)).to eq(['First'])
  end

  it 'by channel_id' do
    channel = build_stubbed(:channel)
    create :collection, name: 'First', channel_id: channel.id
    create :collection, name: 'Second'

    results = CollectionQuery.new({ channel_id: [channel.id] }).results
    expect(results.map(&:name)).to eq(['First'])
  end
end

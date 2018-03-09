describe ChannelQuery do
  context 'order' do
    it 'by id ascending' do
      create :channel, name: 'MTV'
      create :channel, name: 'VIVA'

      results = ChannelQuery.new.results
      expect(results.map(&:name)).to eq(['MTV', 'VIVA'])
    end
  end

  it 'filter by channel_ids' do
    channel1 = create(:channel, name: 'Viva')
    channel2 = create(:channel)

    results = ChannelQuery.new({channel_ids: [channel1]}).results
    expect(results.map(&:name)).to eq(['Viva'])
  end
end

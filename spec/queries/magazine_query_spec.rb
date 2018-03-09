describe MagazineQuery do
  context 'order' do
    it 'by created_at' do
      channel = create :channel, id: 9999
      magazine = create(:magazine, created_at: DateTime.now, channel_id: channel.id)
      magazine2 = create(:magazine, created_at: DateTime.now - 1.days, channel_id: channel.id)

      results = MagazineQuery.new({ channel_id: channel.id }).results
      expect(results).to eq([magazine, magazine2])
    end
  end

  context 'search' do
    it 'by title' do
      magazine = create(:magazine, title: 'Forbes')
      create(:magazine, title: 'Viva')
     results = MagazineQuery.new({ search: 'For' }).results
      expect(results).to eq([magazine])
    end
  end

  context 'filters' do
    it 'channel filter' do
      channel = create :channel, id: 9999
      channel_magazine = create(:magazine, channel_id: channel.id)
      another_channel_magazine = create(:magazine)

      results = MagazineQuery.new({ channel_id: channel.id }).results
      expect(results).to eq([channel_magazine])
    end
  end
end

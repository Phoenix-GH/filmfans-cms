describe TvShowQuery do
  context 'order' do
    it 'by created_at' do
      tv_show = create(:tv_show, created_at: DateTime.now)
      tv_show2 = create(:tv_show, created_at: DateTime.now - 1.days)

      results = TvShowQuery.new.results
      expect(results).to eq([tv_show, tv_show2])
    end
  end

  context 'search' do
    it 'by title' do
      tv_show = create(:tv_show, title: 'Koło fortuny')
      create(:tv_show, title: 'Jeden z dziesięciu')

      results = TvShowQuery.new({ search: 'Koło' }).results
      expect(results).to eq([tv_show])
    end
  end

  context 'filters' do
    it 'channel filter' do
      channel = create :channel, id: 9999
      channel_tv_show = create(:tv_show, channel_id: channel.id)
      another_channel_tv_show = create(:tv_show)

      results = TvShowQuery.new({ channel_id: channel.id }).results
      expect(results).to eq([channel_tv_show])
    end
  end
end

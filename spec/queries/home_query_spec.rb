describe HomeQuery do
  context 'order' do
    it 'by created_at ascending' do
      home = create(:home, created_at: DateTime.now)
      home2 = create(:home, created_at: DateTime.now - 1.days)

      results = HomeQuery.new.results
      expect(results).to eq([home2, home])
    end
  end

  context 'filters' do
    it 'published filter' do
      create(:home, published: false)
      create(:home, published: true, name: 'home')

      results = HomeQuery.new({ published: true }).results
      expect(results.map(&:name)).to eq(['home'])
    end

    it 'home_type filter' do
      create(:home, home_type: 'man')
      create(:home, home_type: 'woman', name: 'home')

      results = HomeQuery.new({ home_type: 'woman' }).results
      expect(results.map(&:name)).to eq(['home'])
    end
  end
end

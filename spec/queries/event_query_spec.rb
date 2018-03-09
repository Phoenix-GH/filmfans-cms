describe EventQuery do
  context 'order' do
    it 'by created_at ascending' do
      event = create(:event, created_at: DateTime.now)
      event2 = create(:event, created_at: DateTime.now - 1.days)

      results = EventQuery.new.results
      expect(results).to eq([event2, event])
    end
  end

  context 'search' do
    it 'by name' do
      event = create(:event, name: 'challenge')
      create(:event, name: 'hackathon')

      results = EventQuery.new({ search: 'alle' }).results
      expect(results).to eq([event])
    end
  end
end

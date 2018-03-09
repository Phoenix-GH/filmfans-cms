describe CollectionsContainerQuery do
  context 'order' do
    it 'by created_at ascending' do
      create :collections_container, name: 'Yesterday', created_at: Date.yesterday
      create :collections_container, name: 'Today', created_at: Date.today

      results = CollectionsContainerQuery.new.results
      expect(results.map(&:name)).to eq(['Yesterday', 'Today'])
    end
  end
end

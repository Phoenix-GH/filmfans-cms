describe AdminQuery do
  context 'order' do
    it 'by id ascending' do
      create :admin, email: 'first@example.com'
      create :admin, email: 'second@example.com'

      results = AdminQuery.new.results
      expect(results.map(&:email)).to eq(['first@example.com', 'second@example.com'])
    end
  end

  it 'search by email' do
    create :admin, email: 'first@example.com'
    create :admin, email: 'second@example.com'

    results = AdminQuery.new({ search: 'Fir' }).results
    expect(results.map(&:email)).to eq(['first@example.com'])
  end
end

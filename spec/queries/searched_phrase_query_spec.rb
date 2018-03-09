describe SearchedPhraseQuery do
  context 'order' do
    it 'by counter' do
      popular = create(:searched_phrase, counter: 2)
      less_popular = create(:searched_phrase, counter: 1)
      unpopular = create(:searched_phrase, counter: 0)

      results = SearchedPhraseQuery.new.results
      expect(results).to eq([popular, less_popular, unpopular])
    end
  end

  it 'search by phrase' do
    create(:searched_phrase, phrase: 'popular phrase')
    create(:searched_phrase, phrase: 'something else')

    results = SearchedPhraseQuery.new({ search: 'phrase' }).results
    expect(results.map(&:phrase)).to eq(['popular phrase'])
  end
end

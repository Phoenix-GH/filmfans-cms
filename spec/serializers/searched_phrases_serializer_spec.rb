describe SearchedPhrasesSerializer do
  it 'return' do
    phrase = create(:searched_phrase, phrase: 'most popular phrase', counter: 2)
    results = SearchedPhrasesSerializer.new(phrase).results

    expect(results).to eq(
      {
        phrase: 'most popular phrase'
      }
    )
  end

  it 'missing values' do
    phrase = create(:searched_phrase, phrase: nil)
    results = SearchedPhrasesSerializer.new(phrase).results

    expect(results).to eq({})
  end

  it 'empty phrase' do
    phrase = create(:searched_phrase, phrase: '')
    results = SearchedPhrasesSerializer.new(phrase).results

    expect(results).to eq({})
  end
end

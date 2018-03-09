describe 'Searched phrases requests' do
  it '/api/v1/searched_phrases?search=phrase' do
    create(
      :searched_phrase,
      phrase: 'most popular phrase',
      counter: 2
    )
    create(
      :searched_phrase,
      phrase: 'less popular phrase',
      counter: 1
    )
    create(:searched_phrase, phrase: 'something else')

    get '/api/v1/searched_phrases?search=phrase'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['phrase'] }).to eq(['most popular phrase', 'less popular phrase'])
  end
end

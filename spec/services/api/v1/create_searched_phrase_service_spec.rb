describe Api::V1::CreateSearchedPhraseService do
  it 'call: create new searched phrase' do
    form = double(
      phrase: 'nike shoes form woman',
      valid?: true
    )

    service = Api::V1::CreateSearchedPhraseService.new(form)
    expect { service.call }.to change { SearchedPhrase.count }.by(1)
    expect(SearchedPhrase.last.counter).to eq(1)
  end

  it 'call: updates counter of existing phrase' do
    searched_phrase = create(:searched_phrase, phrase: 'nike shoes', counter: 5)
    form = double(
      phrase: 'nike shoes',
      valid?: true
    )

    service = Api::V1::CreateSearchedPhraseService.new(form)
    expect { service.call }.to change { SearchedPhrase.count }.by(0)
    expect(searched_phrase.reload.counter).to eq(6)
  end

  context 'searched phrase to short' do
    it 'call: does not create a new searched phrase' do
      form = double(
        phrase: 'abc',
        valid?: true
      )

      service = Api::V1::CreateSearchedPhraseService.new(form)
      expect { service.call }.to change { SearchedPhrase.count }.by(0)
    end
  end

  context 'profane phrase' do
    it 'call: does not create a new searched phrase' do
      form = double(
        valid?: false
      )

      service = Api::V1::CreateSearchedPhraseService.new(form)
      expect { service.call }.to change { SearchedPhrase.count }.by(0)
    end
  end
end

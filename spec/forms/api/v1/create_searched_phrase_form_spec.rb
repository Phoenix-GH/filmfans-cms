describe Api::V1::CreateSearchedPhraseForm do
  context 'default language: english' do
    it 'profane' do
      form = Api::V1::CreateSearchedPhraseForm.new('fuck')

      expect(form.valid?).to eq false
    end

    it 'valid' do
      form = Api::V1::CreateSearchedPhraseForm.new('word')

      expect(form.valid?).to eq true
    end
  end

  context 'english' do
    it 'profane' do
      form = Api::V1::CreateSearchedPhraseForm.new('fuck', 'en')

      expect(form.valid?).to eq false
    end

    it 'valid' do
      form = Api::V1::CreateSearchedPhraseForm.new('word', 'en')

      expect(form.valid?).to eq true
    end
  end

  context 'other language' do
    it 'profane' do
      form = Api::V1::CreateSearchedPhraseForm.new('kurwa', 'pl')

      expect(form.valid?).to eq false
    end

    it 'valid' do
      form = Api::V1::CreateSearchedPhraseForm.new('fuck', 'pl')

      expect(form.valid?).to eq true
    end
  end

  context 'language without yaml file' do
    it 'profane' do
      form = Api::V1::CreateSearchedPhraseForm.new('fuck', 'fr')

      expect(form.valid?).to eq false
    end

    it 'valid' do
      form = Api::V1::CreateSearchedPhraseForm.new('merde', 'fr')

      expect(form.valid?).to eq true
    end
  end
end

describe Panel::CreateHomeForm do
  it 'valid' do
    params = {
      name: 'New name',
      home_type: 2
    }

    form = Panel::CreateHomeForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name present' do
      params = {
        name: nil,
        home_type: 2
      }

      form = Panel::CreateHomeForm.new(params)
      expect(form.valid?).to eq false
    end

    it 'home_type present' do
      params = {
        name: 'name',
        home_type: nil
      }

      form = Panel::CreateHomeForm.new(params)
      expect(form.valid?).to eq false
    end
  end
end

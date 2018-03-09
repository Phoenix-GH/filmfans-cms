describe Panel::UpdateHomeForm do
  it 'valid' do
    params = {
      name: 'name',
      home_type: 1
    }

    form = Panel::UpdateHomeForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'home_type present' do
      params = {
        name: '',
      }

      form = Panel::UpdateHomeForm.new(params)
      expect(form.valid?).to eq false
    end
  end
end

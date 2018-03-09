describe Panel::CreateEventDetailsForm do
  it 'valid' do
    params = {
      name: 'New name'
    }

    form = Panel::CreateEventDetailsForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      params = {
        name: nil
      }

      form = Panel::CreateEventDetailsForm.new(params)
      expect(form.valid?).to eq false
    end
  end
end

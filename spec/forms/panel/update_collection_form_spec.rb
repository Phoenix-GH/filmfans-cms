describe Panel::UpdateCollectionForm do
  it 'valid' do
    params = {
      name: 'New name'
    }

    form = Panel::UpdateCollectionForm.new(params)

    expect(form.valid?).to eq true
  end
end

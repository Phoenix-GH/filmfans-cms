describe Panel::CreateMediaOwnerForm do
  it 'valid' do
    media_owner_form_params = attributes_for :media_owner

    form = Panel::CreateMediaOwnerForm.new(media_owner_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      media_owner_form_params = attributes_for :media_owner, name: ''
      form = Panel::CreateMediaOwnerForm.new(media_owner_form_params)

      expect(form.valid?).to eq false
    end
  end
end

describe Panel::UpdateMediaOwnerForm do
  it 'valid' do
    media_owner_attributes = attributes_for :media_owner
    media_owner_form_params = attributes_for :media_owner, name: 'New Name'

    form = Panel::UpdateMediaOwnerForm.new(media_owner_attributes, media_owner_form_params)

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
  end

  context 'invalid' do
    it 'name' do
      media_owner_attributes = attributes_for :media_owner
      media_owner_form_params = attributes_for :media_owner, name: ''

      form = Panel::UpdateMediaOwnerForm.new(media_owner_attributes, media_owner_form_params)

      expect(form.valid?).to eq false
    end
  end
end

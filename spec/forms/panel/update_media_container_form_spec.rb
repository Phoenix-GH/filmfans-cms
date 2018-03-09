describe Panel::UpdateMediaContainerForm do
  it 'valid' do
    content = create(:media_content)
    media_owner = create(:media_owner)
    media_container_attributes = {
      name: 'Old Name',
      description: 'Old Description',
      additional_description: 'Old Additional Description',
      owner: media_owner,
      media_content_id: content.id
    }
    media_container_form_params = {
      name: 'New Name',
      description: 'New Description',
      additional_description: 'New Additional Description'
    }

    form = Panel::UpdateMediaContainerForm.new(
      media_container_attributes,
      media_container_form_params
    )

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
    expect(form.description).to eq 'New Description'
    expect(form.additional_description).to eq 'New Additional Description'
  end

  context 'invalid' do
    it 'name: presence' do
      content = create(:media_content)
      media_owner = create(:media_owner)
      media_container_attributes = {
        name: 'Old Name',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        owner: media_owner,
        media_content_id: content.id
      }
      media_container_form_params = { name: '' }

      form = Panel::UpdateMediaContainerForm.new(
        media_container_attributes,
        media_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'owner: presence' do
      media_owner = create(:media_owner)
      content = create(:media_content)
      media_container_attributes = {
        name: 'Old Name',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        owner: media_owner,
        media_content_id: content.id
      }
      media_container_form_params = { owner: '' }

      form = Panel::UpdateMediaContainerForm.new(
        media_container_attributes,
        media_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'media_content_id: presence' do
      media_owner = create(:media_owner)
      content = create(:media_content)
      media_container_attributes = {
        name: 'Old Name',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        owner: media_owner,
        media_content_id: content.id
      }

      media_container_form_params = { media_content_id: '' }

      form = Panel::UpdateMediaContainerForm.new(
        media_container_attributes,
        media_container_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end

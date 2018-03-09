describe Panel::CreateMediaContainerForm do
  it 'valid' do
    media_content = create(:media_content)
    media_owner = create(:media_owner)
    media_container_form_params = {
      name: 'Old Name',
      description: 'Old Description',
      additional_description: 'Old Additional Description',
      owner: media_owner,
      media_content_id: media_content.id
    }

    form = Panel::CreateMediaContainerForm.new(media_container_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      media_content = create(:media_content)
      media_owner = create(:media_owner)
      media_container_form_params = {
        name: '',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        owner: media_owner,
        media_content_id: media_content.id
      }

      form = Panel::CreateMediaContainerForm.new(media_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'owner: presence' do
      media_content = create(:media_content)
      media_container_form_params = {
        name: 'Old Name',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        media_content_id: media_content.id
      }

      form = Panel::CreateMediaContainerForm.new(media_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'file: not present' do
      media_owner = create(:media_owner)
      media_container_form_params = {
        name: 'Old Name',
        description: 'Old Description',
        additional_description: 'Old Additional Description',
        owner: media_owner,
        media_content_id: nil
      }

      form = Panel::CreateMediaContainerForm.new(media_container_form_params)

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq [
        "First upload file. Allowed formats: image or video"
      ]
    end
  end
end

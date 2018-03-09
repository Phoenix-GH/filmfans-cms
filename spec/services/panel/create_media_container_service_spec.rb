describe Panel::CreateMediaContainerService do
  it 'call' do
    media_owner = create(:media_owner)
    media_container_attributes = {
      name: 'Name',
      description: 'Description',
      owner: media_owner,
      media_content: build(:media_content)
    }

    form = double(
      valid?: true,
      media_container_attributes: media_container_attributes
    )

    service = Panel::CreateMediaContainerService.new(form)
    expect{ service.call }.to change{ MediaContainer.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      media_owner = create(:media_owner)
      media_container_attributes = {
        name: '',
        description: 'Description',
        owner: media_owner,
      }
      form = double(
        valid?: false,
        media_container_attributes: media_container_attributes
      )

      service = Panel::CreateMediaContainerService.new(form)
      expect(service.call).to eq(false)
      expect{ service.call }.to change{ MediaContainer.count }.by(0)
    end
  end
end

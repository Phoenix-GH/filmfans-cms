describe Panel::UpdateMediaContainerService do
  it 'call' do
    media_owner = create(:media_owner)
    media_container = create :media_container, owner: media_owner, name: 'Old name'
    form = double(
      valid?: true,
      media_container_attributes: { name: 'New name' }
    )

    service = Panel::UpdateMediaContainerService.new(media_container, form)
    expect(service.call).to eq true
    expect(media_container.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      media_owner = create(:media_owner)
      media_container = create :media_container, owner: media_owner, name: 'Old name'
      form = double(
        valid?: false,
        media_container_attributes: { name: '' }
      )

      service = Panel::UpdateMediaContainerService.new(media_container, form)
      expect(service.call).to eq false
      expect(media_container.reload.name).to eq 'Old name'
    end
  end
end

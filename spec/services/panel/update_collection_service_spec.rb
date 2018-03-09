describe Panel::UpdateCollectionService do
  it 'call' do
    collection = create(:collection, :with_media_container, :with_cover_image, :with_background_image, name: 'old name')
    form = double(
      valid?: true,
      collection_attributes: {
        name: 'New name'
      },
      background_image_attributes: {},
      cover_image_attributes: {}
    )

    Panel::UpdateCollectionService.new(collection, form).call
    expect(collection.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      collection = create(:collection)
      form = double(
        valid?: false
      )

      service = Panel::UpdateCollectionService.new(collection, form)
      expect(service.call).to eq(false)
    end
  end
end

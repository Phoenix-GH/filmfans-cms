describe Panel::UpdateMediaOwnerService do
  it 'call' do
    media_owner = create :media_owner, name: 'Old name'
    form = double(
      valid?: true,
      attributes: { name: 'New name' },
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") },
      background_image_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::UpdateMediaOwnerService.new(media_owner, form)
    expect(service.call).to eq(true)
    expect(media_owner.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      media_owner = create :media_owner, name: 'Old name'
      form = double(
        valid?: false,
        attributes: { name: '' },
        picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") },
        background_image_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
      )

      service = Panel::UpdateMediaOwnerService.new(media_owner, form)
      expect(service.call).to eq(false)
      expect(media_owner.reload.name).to eq 'Old name'
    end
  end
end

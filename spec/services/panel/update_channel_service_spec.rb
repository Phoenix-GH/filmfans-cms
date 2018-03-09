describe Panel::UpdateChannelService do
  it 'call' do
    channel = create :channel, name: 'Old name'
    form = double(
      valid?: true,
      attributes: { name: 'New name' },
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::UpdateChannelService.new(channel, form)
    expect(service.call).to eq(true)
    expect(channel.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      channel = create :channel, name: 'Old name'
      form = double(
        valid?: false,
        attributes: { name: '' },
        picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
      )

      service = Panel::UpdateChannelService.new(channel, form)
      expect(service.call).to eq(false)
      expect(channel.reload.name).to eq 'Old name'
    end
  end
end

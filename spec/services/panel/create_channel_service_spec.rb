describe Panel::CreateChannelService do
  it 'call' do
    admin = create :admin, role: Role::Admin
    channel_attributes = {
      name: 'Name'
    }
    form = double(
      valid?: true,
      attributes: channel_attributes,
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::CreateChannelService.new(form, admin)
    expect { service.call }.to change { Channel.count }.by(1)
    expect { service.call }.to change { ChannelModerator.count }.by(0)
  end

  it 'create ChannelModerator' do
    admin = create :admin, role: Role::Moderator
    channel_attributes = {
      name: 'Name'
    }
    form = double(
      valid?: true,
      attributes: channel_attributes,
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::CreateChannelService.new(form, admin)
    expect { service.call }.to change { Channel.count }.by(1)
    expect { service.call }.to change { ChannelModerator.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Admin
      channel_attributes = {
        name: ''
      }
      form = double(
        valid?: false,
        attributes: channel_attributes,
        picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
      )

      service = Panel::CreateChannelService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Channel.count }.by(0)
      expect { service.call }.to change { ChannelModerator.count }.by(0)
    end
  end
end

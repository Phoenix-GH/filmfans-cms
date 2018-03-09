describe Panel::CreateMediaOwnerService do
  it 'call' do
    admin = create :admin, role: Role::Admin
    media_owner_attributes = {
      name: 'Name',
      url: 'Url',
    }
    form = double(
      valid?: true,
      attributes: media_owner_attributes,
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") },
      background_image_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::CreateMediaOwnerService.new(form, admin)
    expect { service.call }.to change { MediaOwner.count }.by(1)
    expect { service.call }.to change { MediaOwnerModerator.count }.by(0)
  end

  it 'create MediaOwnerModerator' do
    admin = create :admin, role: Role::Moderator
    media_owner_attributes = {
      name: 'Name',
      url: 'Url',
    }
    form = double(
      valid?: true,
      attributes: media_owner_attributes,
      picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") },
      background_image_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
    )

    service = Panel::CreateMediaOwnerService.new(form, admin)
    expect { service.call }.to change { MediaOwner.count }.by(1)
    expect { service.call }.to change { MediaOwnerModerator.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Admin
      media_owner_attributes = {
        name: '',
        url: 'Url',
      }
      form = double(
        valid?: false,
        attributes: media_owner_attributes,
        picture_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") },
        background_image_attributes: { file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
      )

      service = Panel::CreateMediaOwnerService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change { MediaOwner.count }.by(0)
      expect { service.call }.to change { MediaOwnerModerator.count }.by(0)
    end
  end
end

describe Panel::CreateCollectionService do
  it 'call' do
    admin = create :admin, role: Role::Moderator
    form = double(
      valid?: true,
      collection_attributes: {
        name: 'New name'
      },
      background_image_attributes: {},
      cover_image_attributes: {}
    )

    service = Panel::CreateCollectionService.new(form, admin)
    expect { service.call }.to change(Collection, :count).by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      form = double(
        valid?: false
      )

      service = Panel::CreateCollectionService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change(Collection, :count).by(0)
    end
  end
end

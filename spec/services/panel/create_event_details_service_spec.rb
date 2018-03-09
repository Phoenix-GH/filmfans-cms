describe Panel::CreateEventDetailsService do
  it 'call' do
    admin = create :admin, role: Role::Moderator
    form = double(
      valid?: true,
      attributes: {
        name: 'Event name'
      },
      background_image_attributes: {},
      cover_image_attributes: {}
    )

    service = Panel::CreateEventDetailsService.new(form, admin)
    expect { service.call }.to change { Event.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      form = double(
        valid?: false
      )

      service = Panel::CreateEventDetailsService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Event.count }.by(0)
    end
  end
end

describe Panel::SendAdminInvitationService do
  it 'call' do
    current_admin = create(:admin)
    channel = create(:channel)

    form = double(
      valid?: true,
      attributes: {
        email: 'admin@example.com',
        role: Role::Moderator,
        channel_ids: [channel.id]
      }
    )

    service = Panel::SendAdminInvitationService.new(current_admin, form)
    expect{ service.call }.to change(Admin, :count).by(1)
    expect(Admin.last.role).to eq(Role::Moderator)
    expect(Admin.last.channel_ids).to eq([channel.id])
  end

  context 'form invalid' do
    it 'returns false' do
      current_admin = build(:admin)

      form = double(
        valid?: false,
        attributes: {
          email: ''
        }
      )

      service = Panel::SendAdminInvitationService.new(current_admin, form)
      expect(service.call).to eq(false)
      expect{ service.call }.to change(Admin, :count).by(0)
    end
  end
end

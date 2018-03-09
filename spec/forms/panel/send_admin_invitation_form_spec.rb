describe Panel::SendAdminInvitationForm do
  it 'valid' do
    admin = create(:admin, role: Role::Admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'admin'
      },
      admin
    )

    expect(form.valid?).to eq true
  end

  it 'valid: with Moderator' do
    admin = create(:admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'moderator',
        channel_ids: [1],
        media_owner_ids: [1]
      },
      admin
    )

    expect(form.valid?).to eq true

  end

  it 'valid: with Moderator and only media_owners' do
    admin = create(:admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'moderator',
        media_owner_ids: [1]
      },
      admin
    )
    expect(form.valid?).to eq true
  end

  it 'invalid: wrong email' do
    admin = create(:admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin',
        role: 'admin',
        channel_ids: [1]
      },
      admin
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: email present' do
    admin = create(:admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        role: 'admin',
        channel_ids: [1]
      },
      admin
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: Moderator without channel_ids or media_owner_ids' do
    admin = create(:admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'moderator'
      },
      admin
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: when not ability' do
    admin = create(:admin, role: Role::Admin)
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'super_admin',
        channel_ids: [1]
      },
      admin
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: assign wrong channel' do
    channel = create(:channel)
    channel2 = create(:channel)
    admin = create(:admin, role: Role::Moderator, channels: [channel])
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'moderator',
        channel_ids: [channel2.id]
      },
      admin
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: assign wrong media_owner' do
    media_owner = create(:media_owner)
    media_owner2 = create(:media_owner)
    admin = create(:admin, role: Role::Moderator, media_owners: [media_owner])
    form = Panel::SendAdminInvitationForm.new(
      {
        email: 'admin@example.com',
        role: 'moderator',
        media_owner_ids: [media_owner2.id]
      },
      admin
    )

    expect(form.valid?).to eq false
  end
end

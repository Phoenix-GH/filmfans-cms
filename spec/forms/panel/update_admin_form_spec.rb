describe Panel::UpdateAdminForm do
  it 'valid' do
    admin = create(:admin, role: Role::SuperAdmin)
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::SuperAdmin,
        active: false
      },
      {
        role: 'admin',
        active: true
      }
    )

    expect(form.valid?).to eq true
    expect(form.role).to eq 'admin'
  end

  it 'valid: with Moderator' do
    admin = create(:admin)
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::SuperAdmin,
        active: true
      },
      {
        role: 'moderator',
        channel_ids: [1],
        media_owner_ids: [1],
        active: true
      }
    )

    expect(form.valid?).to eq true
    expect(form.channel_ids).to eq [1]
    expect(form.media_owner_ids).to eq [1]
  end

  it 'valid: with Moderator and only media_owners' do
    admin = create(:admin)
    form = Panel::UpdateAdminForm.new(
      admin,
      {},
      {
        role: 'moderator',
        media_owner_ids: [1],
        active: true
      }
    )
    expect(form.valid?).to eq true
    expect(form.media_owner_ids).to eq [1]
  end

  it 'invalid: Moderator without channel_ids or media_owner_ids' do
    admin = create(:admin)
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::Moderator,
        active: true
      },
      {
        role: 'moderator',
        active: true
      }
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: when not ability' do
    admin = create(:admin, role: Role::Admin)
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::Admin,
        channel_ids: [1],
        active: true
      },
      {
        role: 'super_admin',
        channel_ids: [1],
        active: true
      }
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: assign wrong channel' do
    channel = create(:channel)
    channel2 = create(:channel)
    admin = create(:admin, role: Role::Moderator, channels: [channel])
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::Moderator,
        channel_ids: [1],
        active: true
      },
      {
        role: 'moderator',
        channel_ids: [channel2.id],
        active: true
      }
    )

    expect(form.valid?).to eq false
  end

  it 'invalid: assign wrong media_owner' do
    media_owner = create(:media_owner)
    media_owner2 = create(:media_owner)
    admin = create(:admin, role: Role::Moderator, media_owners: [media_owner])
    form = Panel::UpdateAdminForm.new(
      admin,
      {
        role: Role::Moderator,
        media_owner_ids: [1],
        active: true
      },
      {
        role: 'moderator',
        media_owner_ids: [media_owner2.id],
        active: true
      }
    )

    expect(form.valid?).to eq false
  end
end

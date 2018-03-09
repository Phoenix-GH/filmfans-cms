describe Panel::ToggleFollowingService do
  context 'toggle' do
    it 'create' do
      user = create(:user)
      media_owner = create(:media_owner)
      form = double(
        valid?: true,
        following_attributes: {
          user_id: user.id,
          followed_id: media_owner.id,
          followed_type: 'MediaOwner'
        }
      )
      service = Panel::ToggleFollowingService.new(form)
      expect { service.call }.to change { Following.count }.by(1)
    end

    it 'destroy' do
      user = create(:user)
      channel = create(:channel)
      create(:following, user: user, followed: channel)
      form = double(
        valid?: true,
        following_attributes: {
          user_id: user.id,
          followed_id: channel.id,
          followed_type: 'Channel'
        }
      )

      service = Panel::ToggleFollowingService.new(form)
      expect { service.call }.to change { Following.count }.by(-1)
    end
  end
end

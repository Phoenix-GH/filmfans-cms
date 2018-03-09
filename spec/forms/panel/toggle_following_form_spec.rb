describe Panel::ToggleFollowingForm do
  it 'valid' do
    user = create(:user)
    media_owner = create(:media_owner)

    form = Panel::ToggleFollowingForm.new(
      {
        user_id: user.id,
        followed_id: media_owner.id,
        followed_type: 'MediaOwner'
      }
    )

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'followed_id' do
      user = create(:user)

      form = Panel::ToggleFollowingForm.new(
        {
          user_id: user.id,
          followed_id: nil,
          followed_type: 'MediaOwner'
        }
      )

      expect(form.valid?).to eq false
    end

    it 'followed_type' do
      user = create(:user)
      media_owner = create(:media_owner)

      form = Panel::ToggleFollowingForm.new(
        {
          user_id: user.id,
          followed_id: media_owner.id,
          followed_type: 'costam'
        }
      )

      expect(form.valid?).to eq false
    end
  end

end

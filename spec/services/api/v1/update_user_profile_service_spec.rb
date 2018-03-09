describe Api::V1::UpdateUserProfileService do
  it 'call' do
    user = create(:user)
    picture  = File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")

    form = double(
      valid?: true,
      user_profile_attributes: {
        picture: picture
      }
    )

    service = Api::V1::UpdateUserProfileService.new(user, form)
    expect(service.call).to eq(true)
    expect(user.profile.reload.picture).to be_present
  end

  it 'call with base64' do
    user = create(:user)
    picture  = File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt")

    form = double(
      valid?: true,
      user_profile_attributes: {
        picture: picture
      }
    )

    service = Api::V1::UpdateUserProfileService.new(user, form)
    expect(service.call).to eq(true)
    expect(user.profile.reload.picture).to be_present
  end

  context 'form invalid' do
    it 'returns false' do
      user = create(:user)
      form = double(
        valid?: false,
        user_profile_attributes: {}
      )

      service = Api::V1::UpdateUserProfileService.new(user, form)
      expect(service.call).to eq(false)
    end
  end
end

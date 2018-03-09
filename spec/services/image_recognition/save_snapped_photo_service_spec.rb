describe ImageRecognition::SaveSnappedPhotoService do
  before do
    @user = create(:user)
    @encoded_image = File.read("#{Rails.root}/spec/fixtures/files/encoded_picture.txt")
  end

  it 'call' do
    service = ImageRecognition::SaveSnappedPhotoService.new(@user, @encoded_image)

    expect { service.call }.to change { SnappedPhoto.count }.by(1)

    snapped_photo = @user.snapped_photos.last
    expect(snapped_photo.image.url).to match(
      /\/uploads\/snapped_photo\/image\/#{snapped_photo.id}\//
    )
  end

  context 'no user' do
    it 'call' do
      service = ImageRecognition::SaveSnappedPhotoService.new(nil, @encoded_image)

      expect(service.call).to eq false
    end
  end

  context 'no image' do
    it 'call' do
      service = ImageRecognition::SaveSnappedPhotoService.new(@user, nil)

      expect(service.call).to eq false
    end
  end
end

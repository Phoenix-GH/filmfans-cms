describe SnappedPhotoSerializer do
  it 'return' do
    snapped_photo = create(:snapped_photo)
    results = SnappedPhotoSerializer.new(snapped_photo).results
    expect(results).to eq(
      {
        id: snapped_photo.id,
        image: snapped_photo.image.url
      }
    )
  end

  it 'missing values' do
    snapped_photo = create(:snapped_photo, image: nil)
    results = SnappedPhotoSerializer.new(snapped_photo).results
    expect(results).to eq(
      {
        id: snapped_photo.id,
        image: PictureUploader.new.default_url
      }
    )
  end
end

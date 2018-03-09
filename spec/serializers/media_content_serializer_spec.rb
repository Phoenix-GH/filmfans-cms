describe MediaContentSerializer do
  context 'file: type image' do
    it 'return' do
      media_content = create(:media_content, :with_file_type_image, :with_cover_image)
      results = MediaContentSerializer.new(media_content).results

      expect(results).to eq(
        {
          image_url: media_content.cover_image.url,
          type: 'image/png',
          url: media_content.file.url.to_s,
          thumbnail_url: '',
          media_container_url: media_content.cover_image.media_container_size.url,
          combo_container_url: media_content.cover_image.combo_container_size.url,
          specification: media_content.specification
        }
      )
    end
  end

  context 'file: type video' do
    it 'return' do
      media_content = create(:media_content, :with_file_type_video, :with_cover_image)
      results = MediaContentSerializer.new(media_content).results

      expect(results).to eq(
        {
          image_url: media_content.cover_image.url,
          type: 'video/mp4',
          url: media_content.file.url.to_s,
          thumbnail_url: '',
          media_container_url: media_content.cover_image.media_container_size.url,
          combo_container_url: media_content.cover_image.combo_container_size.url,
          specification: media_content.specification
        }
      )
    end
  end

  it 'missing values' do
    media_content = build(:media_content, specification: nil)
    results = MediaContentSerializer.new(media_content).results

    expect(results).to eq(
      {
        image_url: '',
        type: '',
        url: '',
        thumbnail_url: '',
        media_container_url: '',
        combo_container_url: '',
        specification: {}
      }
    )
  end
end

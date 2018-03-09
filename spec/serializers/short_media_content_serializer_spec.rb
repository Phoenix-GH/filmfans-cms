describe ShortMediaContentSerializer do
  context 'file: type image' do
    it 'return' do
      media_content = create(:media_content, :with_file_type_image, :with_cover_image)
      results = ShortMediaContentSerializer.new(media_content).results

      expect(results).to eq(
        {
          type: 'image/png',
          url: media_content.file.url.to_s,
          thumbnail_url: media_content.file_thumb_url.to_s
        }
      )
    end
  end

  context 'file: type video' do
    it 'return' do
      media_content = create(:media_content, :with_file_type_video, :with_cover_image)
      results = ShortMediaContentSerializer.new(media_content).results

      expect(results).to eq(
        {
          type: 'video/mp4',
          url: media_content.file.url.to_s,
          thumbnail_url: media_content.file_thumb_url.to_s
        }
      )
    end
  end
end

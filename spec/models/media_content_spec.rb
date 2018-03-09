describe MediaContent do
  describe '#mp4_version_file?' do
    it 'original file mp4: returns original' do
      media_content = create :media_content, :with_file_type_video
      expect(media_content.mp4_version_file).to eq media_content.file
    end

    it 'original file other than mp4: returns converted' do
      media_content = create :media_content, file: Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/video.mp4")), file_type: 'video/mov'
      expect(media_content.mp4_version_file).to eq media_content.file.mp4
    end
  end

  describe '#image?' do
    it 'yes' do
      media_content = create :media_content, :with_file_type_image
      expect(media_content.image?).to be_truthy
    end

    it 'no' do
      media_content = create :media_content, :with_file_type_video
      expect(media_content.image?).to be_falsy
    end
  end

  describe '#video?' do
    it 'yes' do
      media_content = create :media_content, :with_file_type_video
      expect(media_content.video?).to be_truthy
    end

    it 'no' do
      media_content = create :media_content, :with_file_type_image
      expect(media_content.video?).to be_falsy
    end
  end
end

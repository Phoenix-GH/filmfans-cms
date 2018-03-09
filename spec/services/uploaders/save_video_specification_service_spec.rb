describe Uploaders::SaveVideoSpecificationService do
  before do
    FileUploader.enable_processing = true

    @uploader_class = Class.new(CarrierWave::Uploader::Base)
    @uploader = @uploader_class.new
  end

  after do
    FileUploader.enable_processing = false
  end

  context 'original mp4 file' do
    it 'call' do
      model = create :media_content, :with_file_type_video

      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
      file = @uploader.file

      service = Uploaders::SaveVideoSpecificationService.new(model, file)
      expect(service.call).to eq(true)
      expect(model.specification).to eq({
        'height'=>180,
        'width'=>320,
        'duration'=>0.976,
        'video_codec'=> 'mpeg4',
        'audio_codec'=> 'aac',
        'valid'=> true
        })
    end
  end

  context 'converted mp4 file' do
    it 'call' do
      model = create :media_content, :with_file_type_video

      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mov"))
      file = @uploader.file

      service = Uploaders::SaveVideoSpecificationService.new(model, file)
      expect(service.call).to eq(true)
      expect(model.specification).to eq({
        'height'=>180,
        'width'=>320,
        'duration'=>0.697,
        'video_codec'=> 'mpeg4',
        'audio_codec'=> 'aac',
        'valid'=> true
        })
    end
  end
end

require 'carrierwave/test/matchers'

describe VideoUploader do
  include CarrierWave::Test::Matchers

  before :all do
    VideoUploader.enable_processing = true
  end

  before :each do
    @uploader = VideoUploader.new(Episode.new)
  end

  after :all do
    VideoUploader.enable_processing = false
  end

  context 'video file' do
    it 'creates video_thumb version' do
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
      expect(@uploader.versions[:video_thumb].file.content_type).to match(/image\//)
    end

    it 'calls Uploaders::SaveVideoSpecificationService' do
      expect_any_instance_of(Uploaders::SaveVideoSpecificationService).to receive(:call)
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
    end
  end
end

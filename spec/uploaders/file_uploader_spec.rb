require 'carrierwave/test/matchers'

describe FileUploader do
  include CarrierWave::Test::Matchers

  before :all do
    FileUploader.enable_processing = true
  end

  before :each do
    @uploader = FileUploader.new(MediaContent.new)
  end

  after :all do
    FileUploader.enable_processing = false
  end

  context 'image file' do
    before do
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
    end

    it 'has defined content type' do
      expect(@uploader.content_type).to eq('image/png')
    end

    it 'scales down image to have 200 by 200 pixels' do
      expect(@uploader.versions[:thumb]).to have_dimensions(200, 200)
    end

    it 'does not convert to mp4 file' do
      expect(@uploader.versions[:mp4].file).to be_nil
    end
  end

  context 'video file: mp4' do
    before do
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
    end

    it 'has defined content type' do
      expect(@uploader.file.content_type).to eq('video/mp4')
    end

    it 'does not create thumb version' do
      expect(@uploader.versions[:thumb].file).to be_nil
    end

    it 'does not convert to mp4 file' do
      expect(@uploader.versions[:mp4].file).to be_nil
    end
  end

  context 'video file: other format' do
    before do
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/video.mov"))
    end

    it 'has defined content type' do
      expect(@uploader.file.content_type).to match(/video\//)
    end

    it 'does not create thumb version' do
      expect(@uploader.versions[:thumb].file).to be_nil
    end

    it 'converts to mp4 file' do
      expect(@uploader.versions[:mp4].file.file).to match(/video_.*_converted.mp4/)
    end
  end
end

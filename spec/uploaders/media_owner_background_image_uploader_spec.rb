require 'carrierwave/test/matchers'

describe MediaOwnerBackgroundImageUploader do
  include CarrierWave::Test::Matchers

  before :all do
    MediaOwnerBackgroundImageUploader.enable_processing = true
  end

  after :all do
    MediaOwnerBackgroundImageUploader.enable_processing = false
  end

  context 'image file' do
    it 'creates custom version based on specification' do
      picture = create(:media_owner_background_image, specification: {crop_x: '2', crop_y: '3', width: '20', height: '20'})
      @uploader = MediaOwnerBackgroundImageUploader.new(picture)
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
      expect(@uploader.versions[:custom]).to have_dimensions(20, 20)
    end
  end
end
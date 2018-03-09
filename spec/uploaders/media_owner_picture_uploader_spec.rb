require 'carrierwave/test/matchers'

describe MediaOwnerPictureUploader do
  include CarrierWave::Test::Matchers

  before :all do
    MediaOwnerPictureUploader.enable_processing = true
  end

  after :all do
    MediaOwnerPictureUploader.enable_processing = false
  end

  context 'image file' do
    it 'creates custom version based on specification' do
      picture = create(:media_owner_picture, specification: {crop_x: '2', crop_y: '3', width: '20', height: '20'})
      @uploader = MediaOwnerPictureUploader.new(picture)
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
      expect(@uploader.versions[:custom]).to have_dimensions(20, 20)
    end
  end
end
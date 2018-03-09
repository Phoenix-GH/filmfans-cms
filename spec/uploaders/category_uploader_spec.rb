require 'carrierwave/test/matchers'

describe CategoryUploader do
  include CarrierWave::Test::Matchers

  before :all do
    CategoryUploader.enable_processing = true
  end

  before :each do
    @uploader = CategoryUploader.new(Category.new)
  end

  after :all do
    CategoryUploader.enable_processing = false
  end

  context 'image file' do
    before do
      @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
    end

    it 'scales down image to have 220 by 220 pixels' do
      expect(@uploader.versions[:carousel]).to have_dimensions(220, 220)
    end
  end
end

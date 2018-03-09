describe Uploaders::SaveContentTypeService do
  before do
    FileUploader.enable_processing = true

    @uploader_class = Class.new(CarrierWave::Uploader::Base)
    @uploader = @uploader_class.new
    @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
  end

  after do
    FileUploader.enable_processing = false
  end

  it 'call' do
    model = create :media_content, :with_file_type_image, file_type: 'other'
    file = @uploader.file
    service = Uploaders::SaveContentTypeService.new(model, file)

    expect(service.call).to eq(true)
    expect(model.file_type).to eq 'image/png'
  end
end

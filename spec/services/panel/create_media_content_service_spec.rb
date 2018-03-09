describe Panel::CreateMediaContentService do
  it 'call' do
    FileUploader.enable_processing = true
    form = double(
      valid?: true,
      attributes: {
        file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
      }
    )

    service = Panel::CreateMediaContentService.new(form: form)
    expect { service.call }.to change { MediaContent.count }.by(1)
    expect(MediaContent.last.cover_image.file).to be_present
    FileUploader.enable_processing = false
  end

  context 'form invalid' do
    it 'returns false' do
      form = double(
        valid?: false,
        attributes: {
          file: 'Invalid File'
        }
      )

      service = Panel::CreateMediaContentService.new(form: form)
      expect(service.call).to eq(false)
      expect { service.call }.to change { MediaContent.count }.by(0)
    end
  end
end

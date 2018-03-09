describe Panel::CreateProductFileService do
  xit 'call' do
    FileUploader.enable_processing = true
    form = double(
      valid?: true,
      attributes: {
        file: File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
      }
    )

    service = Panel::CreateProductFileService.new(form: form)
    expect { service.call }.to change { ProductFile.count }.by(1)
    expect(ProductFile.last.cover_image).to be_present
    FileUploader.enable_processing = false
  end

  context 'form invalid' do
    xit 'returns false' do
      form = double(
        valid?: false,
        attributes: {
          file: 'Invalid File'
        }
      )

      service = Panel::CreateProductFileService.new(form: form)
      expect(service.call).to eq(false)
      expect { service.call }.to change { ProductFile.count }.by(0)
    end
  end
end

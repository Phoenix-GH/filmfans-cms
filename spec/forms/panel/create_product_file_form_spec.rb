describe Panel::CreateProductFileForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
      File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }

  it 'valid' do
    product_file_form_params = {
      cover_image: image,
      file: 'file'
    }
    form = Panel::CreateProductFileForm.new(product_file_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'file: presence' do
      product_file_form_params = {
        cover_image: image,
        file: ''
      }
      form = Panel::CreateProductFileForm.new(product_file_form_params)

      expect(form.valid?).to eq false
    end

    it 'cover image: extension' do
      invalid_image = Rack::Test::UploadedFile.new(
        File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      product_file_form_params = { file: invalid_image }

      form = Panel::CreateProductFileForm.new(
        product_file_form_params
      )

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq ["File invalid format. Allowed formats: image or video"]
    end
  end
end

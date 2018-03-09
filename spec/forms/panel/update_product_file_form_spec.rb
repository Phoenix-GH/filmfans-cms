describe Panel::UpdateProductFileForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
      File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }

  it 'valid' do
    product_file_attributes = {
      cover_image: 'image',
      file: 'file'
    }
    form = Panel::UpdateProductFileForm.new(
      product_file_attributes,
      { cover_image: image }
    )

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'cover image' do
      product_file_attributes = {
        cover_image: 'image',
        file: 'file'
      }
      form = Panel::UpdateProductFileForm.new(
        product_file_attributes,
        { cover_image: '' }
      )

      expect(form.valid?).to eq false
    end

    it 'cover image format' do
      invalid_image = Rack::Test::UploadedFile.new(
        File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      product_file_attributes = {
        cover_image: 'image',
        file: 'file'
      }
      form = Panel::UpdateProductFileForm.new(
        product_file_attributes,
        { cover_image: invalid_image }
      )

      expect(form.valid?).to eq false
    end
  end
end

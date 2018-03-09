describe Panel::CreateMediaContentForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
      File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }

  it 'valid' do
    media_content_form_params = {
      cover_image: image,
      file: 'file'
    }
    form = Panel::CreateMediaContentForm.new(media_content_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'file: presence' do
      media_content_form_params = {
        cover_image: image,
        file: ''
      }
      form = Panel::CreateMediaContentForm.new(media_content_form_params)

      expect(form.valid?).to eq false
    end

    it 'cover image: extension' do
      invalid_image = Rack::Test::UploadedFile.new(
        File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      media_content_form_params = { file: invalid_image }

      form = Panel::CreateMediaContentForm.new(
        media_content_form_params
      )

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq ["File invalid format. Allowed formats: image or video"]
    end
  end
end

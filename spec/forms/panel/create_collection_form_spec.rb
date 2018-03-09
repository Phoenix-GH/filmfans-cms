describe Panel::CreateCollectionForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
      File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }
  it 'valid' do
    params = {
      name: 'New name',
      background_image: image
    }

    form = Panel::CreateCollectionForm.new(params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      params = {
        name: 'New name'
      }
      form = Panel::CreateCollectionForm.new(params)
      expect(form.valid?).to eq false
    end
  end
end

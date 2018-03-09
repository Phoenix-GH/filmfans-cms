describe Panel::CreateCategoryForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
        File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }

  it 'valid' do
    category_form_params = {
        name: 'Old Name',
        image: image,
        parent_id: 1,
        icon: image
    }

    form = Panel::CreateCategoryForm.new(category_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      category_form_params = {
          name: '',
          image: image,
          parent_id: 1,
          icon: image
      }

      form = Panel::CreateCategoryForm.new(category_form_params)

      expect(form.valid?).to eq false
    end

    it 'image format' do
      invalid_image = Rack::Test::UploadedFile.new(
          File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      category_form_params = {
          name: 'Old Name',
          image: invalid_image,
          parent_id: 1,
          icon: image
      }

      form = Panel::CreateCategoryForm.new(category_form_params)

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq ["Image invalid format"]
    end

    it 'icon format' do
      invalid_image = Rack::Test::UploadedFile.new(
          File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      category_form_params = {
          name: 'Old Name',
          image: image,
          parent_id: 1,
          icon: invalid_image
      }

      form = Panel::CreateCategoryForm.new(category_form_params)

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq ["Icon invalid format"]
    end
  end
end

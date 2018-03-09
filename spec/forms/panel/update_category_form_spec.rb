describe Panel::UpdateCategoryForm do
  let(:image) {
    Rack::Test::UploadedFile.new(
        File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  }

  it 'valid' do
    category_attributes = {
        name: 'Old Name',
        image: image,
        parent_id: 1,
        icon: image
    }
    category_form_params = { name: 'New Name' }

    form = Panel::UpdateCategoryForm.new(
        category_attributes,
        category_form_params
    )

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
  end

  context 'invalid' do
    let(:category_attributes) {
      {
          name: 'Old Name',
          image: image,
          parent_id: 1,
          icon: image
      }
    }

    it 'name' do
      category_form_params = { name: '' }

      form = Panel::UpdateCategoryForm.new(
          category_attributes,
          category_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'image format' do
      invalid_image = Rack::Test::UploadedFile.new(
          File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      category_form_params = { image: invalid_image }

      form = Panel::UpdateCategoryForm.new(
          category_attributes,
          category_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'icon format' do
      invalid_image = Rack::Test::UploadedFile.new(
          File.open("#{Rails.root}/spec/fixtures/files/empty.txt")
      )
      category_form_params = { icon: invalid_image }

      form = Panel::UpdateCategoryForm.new(
          category_attributes,
          category_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end

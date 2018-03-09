describe Panel::CreateCategoryService do
  it 'call' do
    category_attributes = {
        name: 'Name',
        image: 'Image',
        icon: 'Icon',
        parent_id: 1
    }
    form = double(
        valid?: true,
        category_attributes: category_attributes
    )

    service = Panel::CreateCategoryService.new(form)
    expect { service.call }.to change { Category.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      form = double(
          valid?: false
      )

      service = Panel::CreateCategoryService.new(form)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Category.count }.by(0)
    end
  end
end

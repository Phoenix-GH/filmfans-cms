describe Panel::UpdateCategoryService do
  it 'call' do
    category = create :category, name: 'Old name'
    form = double(
        valid?: true,
        category_attributes: { name: 'New name' },
    )

    service = Panel::UpdateCategoryService.new(category, form)
    expect(service.call).to eq true
    expect(category.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      category = create :media_container, name: 'Old name'
      form = double(
          valid?: false
      )

      service = Panel::UpdateCategoryService.new(category, form)
      expect(service.call).to eq false
    end
  end
end

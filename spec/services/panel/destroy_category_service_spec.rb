describe Panel::DestroyCategoryService do
  it 'call' do
    category = create :category

    service = Panel::DestroyCategoryService.new(category)
    expect { service.call }.to change { Category.count }.by(-1)
  end

  context 'category with products' do
    it 'returns false' do
      product = create :product
      category = create :category
      create :product_category, product: product, category: category

      service = Panel::DestroyCategoryService.new(category)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Category.count }.by(0)
    end
  end
end

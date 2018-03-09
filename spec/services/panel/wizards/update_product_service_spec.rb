describe Panel::Wizards::UpdateProductService do
  xit 'call' do
    category = create(:category)
    product = create :product, name: 'Old name'
    create(:product_category, product: product, category: category)
    form = double(
      valid?: true,
      product_attributes: { name: 'New name' },
    )
    allow_any_instance_of(Panel::Wizards::UpdateProductService).to receive(:update_product_categories).and_return(true)
    service = Panel::Wizards::UpdateProductService.new(product, form)
    expect(service.call).to eq(true)
    expect(product.reload.name).to eq 'New name'
  end

  context 'form invalid' do
    it 'returns false' do
      product = create :product, name: 'Old name'
      form = double(
        valid?: false,
        product_attributes: { name: '' },
        product_file_attributes: { cover_image: '' }
      )

      service = Panel::Wizards::UpdateProductService.new(product, form)
      expect(service.call).to eq(false)
      expect(product.reload.name).to eq 'Old name'
    end
  end
end

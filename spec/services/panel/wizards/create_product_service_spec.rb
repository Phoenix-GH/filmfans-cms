describe Panel::Wizards::CreateProductService do
  it 'call' do
    category = create(:category)
    product_attributes = {
      name: 'name',
      brand: 'brand',
      shipping_info: 'shipping_info',
      vendor_url: 'vendor_url',
      category_ids: category.id
    }
    form = double(
      valid?: true,
      product_attributes: product_attributes,
      product_file_attributes: []
    )
    allow_any_instance_of(Panel::Wizards::CreateProductService).to receive(:add_product_categories).and_return(true)
    service = Panel::Wizards::CreateProductService.new(form)
    expect { service.call }.to change { Product.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      product_attributes = {
        name: '',
        brand: 'brand',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        category_ids: [20]
      }
      form = double(
        valid?: false,
        product_attributes: product_attributes,
        product_file_attributes: []
      )

      service = Panel::Wizards::CreateProductService.new(form)
      expect(service.call).to eq(false)
      expect { service.call }.to change { Product.count }.by(0)
    end
  end
end

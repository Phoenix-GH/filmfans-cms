describe Panel::DestroyProductFileService do
  it 'call' do
    product = create :product
    create_list :product_file, 2, product: product
    product_file = create :product_file, product: product

    service = Panel::DestroyProductFileService.new(product_file)
    expect { service.call }.to change { ProductFile.count }.by(-1)
  end

  context 'first file for the product' do
    it 'returns false' do
      product = create :product
      product_file = create :product_file, product: product

      service = Panel::DestroyProductFileService.new(product_file)
      expect { service.call }.to change { ProductFile.count }.by(0)
    end
  end
end

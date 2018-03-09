describe Panel::DestroyProductService do
  it 'destroy product' do
    product = create(:product)
    service = Panel::DestroyProductService.new(product)
    expect{ service.call }.to change(Product, :count).by(-1)
  end

  it 'destroy product_similarity' do
    product = create(:product)
    create(:product_similarity, product_from: product)
    create(:product_similarity, product_to: product)

    service = Panel::DestroyProductService.new(product)
    expect{ service.call }.to change(ProductSimilarity, :count).by(-2)
  end
end

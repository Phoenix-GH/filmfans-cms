describe Panel::CreateSimilarProductsService do
  it "create new relations" do
    product1 = create(:product)
    product2 = create(:product)
    product3 = create(:product)
    expect{
      Panel::CreateSimilarProductsService.new(product1, [product2.id, product3.id]).call
    }.to change(ProductSimilarity, :count).by(4) # four relation because two site
  end

  it "remove old relations" do
    product1 = create(:product)
    product2 = create(:product)
    product3 = create(:product)
    create(:product_similarity, product_from: product2, product_to: product1)
    create(:product_similarity, product_from: product1, product_to: product2)

    Panel::CreateSimilarProductsService.new(product1, [product3.id]).call
    expect(
      ProductSimilarity.where(product_from: product1, product_to: product2).any?
    ).to be false
    expect(
      ProductSimilarity.where(product_from: product1, product_to: product3).any?
    ).to be true
  end
end

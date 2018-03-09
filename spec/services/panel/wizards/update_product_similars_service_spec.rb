describe Panel::Wizards::UpdateProductSimilarsService do
  it 'update' do
    product = create :product
    product2 = create :product
    product3 = create :product
    product4 = create :product
    create(:product_similarity, product_from: product, product_to: product2)
    similar_products_attr = [
      { product_to_id: product3.id },
      { product_to_id: product4.id }
    ]

    form = double(
      valid?: true,
      similar_products_attributes:{
        similar_products_attributes: similar_products_attr
      },
      similar_products: ProductSimilarity.create(similar_products_attr)
    )

    expect{
      Panel::Wizards::UpdateProductSimilarsService.new(product, form).call
    }.to change(ProductSimilarity, :count).by(1)
    product_similarity = ProductSimilarity.last
    expect(product_similarity.product_from).to eq(product)
    expect(product_similarity.product_to).to eq(product4)
  end

  it 'create' do
    product = create :product
    product2 = create :product
    product3 = create :product

    similar_products_attr = [
      { product_to_id: product2.id },
      { product_to_id: product3.id }
    ]

    form = double(
      valid?: true,
      similar_products_attributes:{
        similar_products_attributes: similar_products_attr
      },
      similar_products: ProductSimilarity.create(similar_products_attr)
    )

    expect{
      Panel::Wizards::UpdateProductSimilarsService.new(product, form).call
    }.to change(ProductSimilarity, :count).by(2)
    product_similarity = ProductSimilarity.last
    expect(product_similarity.product_from).to eq(product)
    expect(product_similarity.product_to).to eq(product3)
  end

  it 'delete' do
    product = create :product
    product2 = create :product
    create(:product_similarity, product_from: product, product_to: product2)
    similar_products_attr = []

    form = double(
      valid?: true,
      similar_products_attributes:{
        similar_products_attributes: similar_products_attr
      },
      similar_products: ProductSimilarity.create(similar_products_attr)
    )

    expect{
      Panel::Wizards::UpdateProductSimilarsService.new(product, form).call
    }.to change(ProductSimilarity, :count).by(-1)
  end


  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      product = create :product
      product2 = create :product
      similar_products_attr = [
        { product_to_id: product2.id }
      ]

      form = double(
        valid?: false,
        products_container_attributes: similar_products_attr
      )

      service = Panel::CreateProductsContainerService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change(ProductSimilarity, :count).by(0)
    end
  end
end

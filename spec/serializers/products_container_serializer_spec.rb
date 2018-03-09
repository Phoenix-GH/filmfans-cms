describe ProductsContainerSerializer do
  it 'return' do
    owner = create(:media_owner)
    media_content = create(:media_content)
    products_container = build_stubbed(:products_container,
      name: 'beautiful products',
      description: 'description',
      media_owner_id: owner.id,
      media_content: media_content
    )
    product = build(:product)
    product2 = build(:product)
    create(:linked_product,
      position: 2,
      product: product,
      products_container: products_container
    )
    create(:linked_product,
      position: 1,
      product: product2,
      products_container: products_container
    )

    results = ProductsContainerSerializer.new(products_container).results

    expect(results).to eq(
      {
        type: 'combo_container',
        id: products_container.id,
        name: 'beautiful products',
        description: 'description',
        date: products_container.created_at.to_s,
        products: [
          ProductSerializer.new(product2, with_similar_products: false).results,
          ProductSerializer.new(product, with_similar_products: false).results
        ],
        content: MediaContentSerializer.new(media_content).results,
        media_owner: MediaOwnerSerializer.new(owner).results
      }
    )
  end

  it 'missing values' do
    products_container = build(:products_container, name: nil)
    results = ProductsContainerSerializer.new(products_container).results
    expect(results).to eq(
      {
        type: 'products_container',
        id: products_container.id,
        name: '',
        date: '',
        products: []
      }
    )
  end

  it 'removed product' do
    owner = create(:media_owner)
    media_content = create(:media_content)
    products_container = build_stubbed(:products_container,
      name: 'beautiful products',
      description: 'description',
      media_owner_id: owner.id,
      media_content: media_content
    )
    product = build(:product)
    create(:linked_product,
      position: 1,
      product: product,
      products_container: products_container
    )

    product.destroy

    results = ProductsContainerSerializer.new(products_container).results

    expect(results).to eq(
      {
        type: 'combo_container',
        id: products_container.id,
        name: 'beautiful products',
        description: 'description',
        date: products_container.created_at.to_s,
        products: [],
        content: MediaContentSerializer.new(media_content).results,
        media_owner: MediaOwnerSerializer.new(owner).results
      }
    )
  end
end

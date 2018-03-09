describe ProductChannelQuery do
  it 'find products for channel' do
    product = create :product
    product2 = create :product
    category = create :category
    channel = create :channel
    products_container = create :products_container, channel_id: channel.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: channel
    create :tag, product_id: product2.id, media_container_id: media_container.id

    create :product_category, product_id: product.id, category_id: category.id
    create :product_category, product_id: product2.id, category_id: category.id
    results = ProductChannelQuery.new([channel.id]).results
    expect(results).to eq([product2.id, product.id])
  end
end

describe ProductMediaOwnerQuery do
  it 'find products for category and media_owner' do
    product = create :product
    product2 = create :product
    category = create :category
    media_owner = create :media_owner
    products_container = create :products_container, media_owner_id: media_owner.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: media_owner
    create :tag, product_id: product2.id, media_container_id: media_container.id

    create :product_category, product_id: product.id, category_id: category.id
    create :product_category, product_id: product2.id, category_id: category.id
    results = ProductMediaOwnerQuery.new([media_owner.id]).results
    expect(results).to eq([product2.id, product.id])
  end
end

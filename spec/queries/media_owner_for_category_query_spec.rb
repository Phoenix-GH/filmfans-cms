describe MediaOwnerForCategoryQuery do
  it 'find media owners by category' do
    product = create :product
    category = create :category
    media_owner = create :media_owner
    media_owner2 = create :media_owner
    products_container = create :products_container, media_owner_id: media_owner.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: media_owner
    create :tag, product_id: product.id, media_container_id: media_container.id
    media_container2 = create :media_container, owner: media_owner2
    create :tag, product_id: product.id, media_container_id: media_container2.id

    create :product_category, product_id: product.id, category_id: category.id
    results = MediaOwnerForCategoryQuery.new(category.id).results
    expect(results).to eq([media_owner.id, media_owner2.id])
  end
end

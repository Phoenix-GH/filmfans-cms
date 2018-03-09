describe CollectionSerializer do
  it 'return' do
    collection = create(:collection, :with_cover_image, name: 'sample')
    media_container = create(:media_container)
    products_container = create(:products_container)
    combo_container = create(:products_container,
      products: [build(:product)],
      media_content: build(:media_content),
      media_owner: build(:media_owner)
    )
    collection_content = create(:collection_content,
      collection: collection,
      content: media_container,
      position: 2
    )
    collection_content2 = create(:collection_content,
      collection: collection,
      content: products_container,
      position: 1
    )
    collection_content3 = create(:collection_content,
      collection: collection,
      content: combo_container,
      position: 3
    )

    results = CollectionSerializer.new(collection, true).results

    expect(results).to eq({
      id: collection.id,
      name: 'sample',
      image_url: collection.cover_image.custom_url,
      products_containers: [
        ProductsContainerSerializer.new(
          products_container
        ).results.merge(position: collection_content2.position)
      ],
      media_containers: [
        MediaContainerSerializer.new(
          media_container
        ).results.merge(position: collection_content.position)
      ],
          combo_containers: [
            ProductsContainerSerializer.new(
              combo_container
            ).results.merge(position: collection_content3.position)
          ]
    })
  end

  it 'missing values' do
    collection = build(:collection, name: 'sample')
    results = CollectionSerializer.new(collection).results
    expect(results).to eq({
      id: collection.id,
      name: 'sample',
      image_url: ''
    })
  end
end

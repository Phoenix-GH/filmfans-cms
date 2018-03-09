describe CollectionsContainerSerializer do
  it 'return' do
    collections_container = create(:collections_container, name: 'sample')
    collection = create(:collection, :with_cover_image, name: 'second')
    collection2 = create(:collection, :with_cover_image, name: 'first')
    create(:linked_collection,
      position: 2,
      collection: collection,
      collections_container: collections_container
    )
    create(:linked_collection,
      position: 1,
      collection: collection2,
      collections_container: collections_container
    )

    results = CollectionsContainerSerializer.new(collections_container).results

    expect(results).to eq({
      type: 'collections_container',
      name: 'sample',
      collections: [
        {
          id: collection2.id,
          name: "first",
          image_url: collection2.cover_image.custom_url
        }, {
          id: collection.id,
          name: "second",
          image_url: collection.cover_image.custom_url
        }
      ]
    })
  end

  it 'missing values' do
    collections_container = build(:collections_container, name: nil)
    results = CollectionsContainerSerializer.new(collections_container).results
    expect(results).to eq({
      type: 'collections_container',
      name: '',
      collections: []
    })
  end
end

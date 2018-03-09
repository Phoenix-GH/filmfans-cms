describe Panel::UpdateCollectionsContainerService do
  it 'call' do
    collection = create :collection
    collection2 = create :collection
    collection3 = create :collection
    collections_container = create :collections_container, name: 'Old name'
    create :linked_collection, collection_id: collection.id, collections_container_id: collections_container.id
    create :linked_collection, collection_id: collection2.id, collections_container_id: collections_container.id

    linked_collections_attributes =  [{ collection_id: collection2.id, position: 2} ,{collection_id: collection3.id, position: 1}]


    form = double(
      valid?: true,
      collections_container_attributes: {
        name: 'New name' ,
        linked_collections_attributes: linked_collections_attributes
      },
      linked_collections: LinkedCollection.create(linked_collections_attributes)
    )
    Panel::UpdateCollectionsContainerService.new(collections_container, form).call
    expect(collections_container.reload.name).to eq 'New name'
    expect(collections_container.linked_collections.pluck(:collection_id)
    ).to eq [collection2.id ,collection3.id]
  end

  context 'form invalid' do
    it 'returns false' do
      collection = create :collection
      collections_container = create :collections_container, name: 'Old name', collections: [collection]
      form = double(
        valid?: false,
        collections_container_attributes: { name: '' },
      )

      service = Panel::UpdateCollectionsContainerService.new(collections_container, form)
      expect(service.call).to eq false
      expect(collections_container.reload.name).to eq 'Old name'
    end
  end
end

describe Panel::SortCollectionsContainerService do
  it 'reorder positions' do
    container = create(:collections_container)
    create(:linked_collection,
           collection_id: 1,
           collections_container: container,
           position: 1
    )
    create(:linked_collection,
           collection_id: 2,
           collections_container: container,
           position: 2
    )

    params = {
      "0": {
      id: 2,
      position: 1
    },
      "1": {
      id: 1,
      position: 2
    }
    }

    service = Panel::SortCollectionsContainerService.new(container, params)
    service.call
    collections_order = container.reload.linked_collections.order(:position).pluck(:collection_id)
    expect(collections_order).to eq([2, 1])
  end
end

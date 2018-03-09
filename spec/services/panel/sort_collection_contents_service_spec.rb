describe Panel::SortCollectionContentsService do
  it 'reorder positions' do
    collection = create(:collection)
    content = create(:collection_content,
      content_id: 1,
      content_type: 'ProductsContainer',
      collection: collection,
      position: 1
    )
    content2 = create(:collection_content,
      content_id: 1,
      content_type: 'MediaContainer',
      collection: collection,
      position: 2
    )

    params = {
      "0": {
        id: content2.id,
        position: 1
      },
      "1": {
        id: content.id,
        position: 2
      }
    }

    service = Panel::SortCollectionContentsService.new(collection, params)
    service.call
    contents_oreder = collection.reload.collection_contents.order(:position).pluck(:id)
    expect(contents_oreder).to eq([content2.id, content.id])
  end
end

describe Panel::CreateCollectionContentsService do
  it "create new collection contents" do
    collection = create(:collection)
    media_container = create(:media_container)
    products_container = create(:products_container)
    form = double(
      valid?: true,
      collection_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: products_container.id,
          content_type: "ProductsContainer"
        )]
    )

    expect{
      Panel::CreateCollectionContentsService.new(collection, form).call
    }.to change(CollectionContent, :count).by(2)
  end

  it "remove old collection contents" do
    collection = create(:collection)
    media_container = create(:media_container)
    products_container = create(:products_container)
    products_container2 = create(:products_container)
    create(:collection_content, collection: collection, content: media_container)
    create(:collection_content, collection: collection, content: products_container)

    form = double(
      valid?: true,
      collection_contents: [
        OpenStruct.new(
          content_id: media_container.id,
          content_type: "MediaContainer"
        ),
        OpenStruct.new(
          content_id: products_container2.id,
          content_type: "ProductsContainer"
        )]
    )

    Panel::CreateCollectionContentsService.new(collection, form).call
    expect(
      CollectionContent.where(collection: collection, content: media_container).any?
    ).to be true
    expect(
      CollectionContent.where(collection: collection, content: products_container).any?
    ).to be false
    expect(
      CollectionContent.where(collection: collection, content: products_container2).any?
    ).to be true
  end
end

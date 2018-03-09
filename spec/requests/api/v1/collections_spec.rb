describe 'Collections requests' do
  it '/api/v1/collections' do
    create(:collection, name: 'Collection1')
    create(:collection, name: 'Collection2')

    get '/api/v1/collections'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Collection1', 'Collection2'])
  end

  it '/api/v1/collections/:id' do
    collection = create(:collection, name: 'sample')

    #data important for api-blueprint
    media_container = build(
      :media_container,
      name: 'media',
      media_content: build(:media_content, :with_file_type_image)
    )

    products_container = build(:products_container,
      name: 'products container',
      products: [build(:product)],
    )

    combo_container = build(:products_container,
      name: 'combo container',
      products: [build(:product)],
      media_content: build(:media_content),
      media_owner: build(:media_owner)
    )

    create(:collection_content,
      collection: collection,
      content: media_container,
      position: 2
    )
    create(:collection_content,
      collection: collection,
      content: products_container,
      position: 1
    )
    create(:collection_content,
      collection: collection,
      content: combo_container,
      position: 3
    )

    get "/api/v1/collections/#{collection.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('sample')
    expect(body['products_containers'][0]['name']).to eq('products container')
    expect(body['media_containers'][0]['name']).to eq('media')
  end
end

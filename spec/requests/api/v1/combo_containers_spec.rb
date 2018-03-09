describe 'ProductsContainer requests' do
  it '/api/v1/combo_containers/:id' do
    product = build(:product)#data important for api-blueprint
    product2 = build(:product)#data important for api-blueprint
    owner = build(:media_owner)
    media_content = build(:media_content)
    products_container = create(:products_container,
      name: 'combo container',
      products: [product, product2],
      media_owner: owner,
      media_content: media_content
    )

    get "/api/v1/combo_containers/#{products_container.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('combo container')
    expect(body['type']).to eq('combo_container')
  end
end

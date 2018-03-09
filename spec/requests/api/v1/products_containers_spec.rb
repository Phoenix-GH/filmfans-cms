describe 'ProductsContainer requests' do
  it '/api/v1/products_containers/:id' do
    products_container = create(:products_container,
      name: 'products container',
      products: [build(:product), build(:product)],
    )

    get "/api/v1/products_containers/#{products_container.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('products container')
  end
end

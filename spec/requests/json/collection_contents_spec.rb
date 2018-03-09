describe 'CollectionContentsController requests' do
  it 'index' do
    allow_any_instance_of(ApplicationController).to receive(:current_admin).and_return(create(:admin))
    media_container = create(:media_container, name: 'Ali G media')
    media_container2 = create(:media_container, name: 'Kanye West media')
    products_container = create(:products_container,
      name: 'Ali G - products container'
    )
    products_container2 = create(:products_container,
      name: 'Kanye West - products container'
    )

    get "/json/collection_contents?search=Ali"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.count).to eq(2)
    expect(body[0]['name']).to eq('Ali G media')
    expect(body[1]['name']).to eq('Ali G - products container')
    expect(body[0]['token']).to eq("MediaContainer_#{media_container.id}")
    expect(body[1]['token']).to eq("ProductsContainer_#{products_container.id}")
  end
end

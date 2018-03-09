describe 'Categories requests' do
  it '/api/v1/categories' do
    create(:category, name: 'Woman')
    create(:category, name: 'Man')

    get '/api/v1/categories'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Man', 'Woman'])
  end

  it '/api/v1/categories?parent_id=1' do
    woman_category = create(:category, name: 'Woman')
    man_category = create(:category, name: 'Man')
    create(:category, name: 'Woman Shoes', parent_id: woman_category.id)
    create(:category, name: 'Man Shoes', parent_id: man_category.id)

    get "/api/v1/categories?parent_id=#{woman_category.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes'])
  end

  it '/api/v1/categories?parent_name=Woman' do
    woman_category = create(:category, name: 'Woman')
    man_category = create(:category, name: 'Man')
    create(:category, name: 'Woman Shoes', parent_id: woman_category.id)
    create(:category, name: 'Man Shoes', parent_id: man_category.id)

    get "/api/v1/categories?parent_id=#{woman_category.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes'])
  end

  it '/api/v1/categories/tree' do
    woman_category = create(:category, name: 'Woman')
    man_category = create(:category, name: 'Man')
    create(:category, name: 'Woman Shoes', parent_id: woman_category.id)
    create(:category, name: 'Man Shoes', parent_id: man_category.id)

    get '/api/v1/categories/tree'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Man', 'Woman'])
    expect(body.map { |h| h['subcategories'][0]['name'] }).to eq(['Man Shoes', 'Woman Shoes'])
  end
end

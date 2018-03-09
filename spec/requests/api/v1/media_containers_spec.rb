describe 'Media Containers requests' do
  it '/api/v1/media_containers' do
    create(:media_container,
      name: 'Yesterday',
      created_at: Date.yesterday,
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:media_container,
      name: 'Today',
      created_at: Date.today,
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )

    get '/api/v1/media_containers'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Yesterday', 'Today'])
  end

  it '/api/v1/media_containers?last_date=2016-02-16' do
    create(:media_container,
      name: 'Yesterday',
      created_at: Date.yesterday,
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    create :media_container, name: 'Today', created_at: Date.today

    get "/api/v1/media_containers?last_date=#{Date.today}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Yesterday'])
  end

  it '/api/v1/media_containers?media_owner_id=1' do
    owner = build_stubbed(:media_owner)
    create(:media_container,
      name: 'Media Owner content',
      owner: owner,
      media_content: build(:media_content, :with_file_type_image)
    )
    create :media_container, name: 'Another Owner Content'

    get "/api/v1/media_containers?media_owner_id=#{owner.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Media Owner content'])
  end

  it '/api/v1/media_containers/:id' do
    container = create(:media_container,
      name: 'Jennifer Lopez outfit',
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    product = create(:product) #data important for api-blueprint
    create(:tag, product: product, media_container: container) #data important for api-blueprint

    get "/api/v1/media_containers/#{container.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('Jennifer Lopez outfit')
  end
end

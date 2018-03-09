describe 'Products requests' do

  it '/api/v1/products' do
    create(
      :product,
      name: 'First',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    create(
      :product,
      name: 'Second',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )

    get '/api/v1/products'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['First', 'Second'])
  end

  it '/api/v1/products?category_id[]=1' do
    woman_category = build(:category, name: 'Woman')
    product = build(
      :product,
      name: 'Woman Shoes',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    build(:product, name: 'Man Shoes')
    create(:product_category, product: product, category: woman_category)

    get "/api/v1/products", { category_id: [woman_category.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes'])
  end

  it '/api/v1/products?vendor=manual' do
    store = create(:store, name: 'manual')
    product = create(:product, name: 'Woman Shoes')
    variant = create(:variant, product: product, description: 'description')
    create(:variant_store, variant: variant, store: store)
    product2 = create(:product, name: 'Woman Shoes 2')
    variant2 = create(:variant, product: product2, description: 'description')
    create(:variant_store, variant: variant2, store: store)
    build(:product, name: 'Man Shoes')

    get "/api/v1/products", { vendor: [store.name] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes', 'Woman Shoes 2'])
  end


  it '/api/v1/products?category_id[]=1&media_owner_id[]=1' do
    woman_category = create(:category, name: 'Woman')
    product = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'Woman Shoes',
      variants: [create(:variant, :with_variant_store)]
    )
    product2 = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'Woman Shoes 2',
      variants: [create(:variant, :with_variant_store)]
    )
    build(:product, name: 'Man Shoes')
    media_owner = create :media_owner
    products_container = create :products_container, media_owner_id: media_owner.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: media_owner
    create :tag, product_id: product2.id, media_container_id: media_container.id

    create(:product_category, product: product, category: woman_category)
    create(:product_category, product: product2, category: woman_category)
    #create(:product_store, product: product) #data important for api-blueprint

    get "/api/v1/products", { category_id: [woman_category.id], media_owner_id: [media_owner.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes', 'Woman Shoes 2'])
  end

  it '/api/v1/products?category_id[]=1&channel_id[]=1' do
    woman_category = create(:category, name: 'Woman')
    product = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'Woman Shoes',
      variants: [create(:variant, :with_variant_store)]
    )
    product2 = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'Woman Shoes 2',
      variants: [create(:variant, :with_variant_store)]
    )
    build(:product, name: 'Man Shoes')
    channel = create :channel
    products_container = create :products_container, channel_id: channel.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: channel
    create :tag, product_id: product2.id, media_container_id: media_container.id

    create(:product_category, product: product, category: woman_category)
    create(:product_category, product: product2, category: woman_category)

    get "/api/v1/products", { category_id: [woman_category.id], channel_id: [channel.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Woman Shoes', 'Woman Shoes 2'])
  end

  it '/api/v1/products?category_id[]=1&channel_id[]=1&media_owner_id[]=1' do
    woman_category = create(:category, name: 'Woman')
    product = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'Celebrity Woman Shoes',
      variants: [create(:variant, :with_variant_store)]
    )
    product2 = create(
      :product,
      price_range: "$19.99 - $39.99",
      name: 'MTV Woman Shoes',
      variants: [create(:variant, :with_variant_store)]
    )
    build(:product, name: 'Man Shoes')
    channel = create :channel
    media_owner = create :media_owner
    products_container = create :products_container, channel_id: channel.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: media_owner
    create :tag, product_id: product2.id, media_container_id: media_container.id

    create(:product_category, product: product, category: woman_category)
    create(:product_category, product: product2, category: woman_category)

    get "/api/v1/products?page=1&per=1000", {
      category_id: [woman_category.id],
      channel_id: [channel.id],
      media_owner_id: [media_owner.id]
    }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Celebrity Woman Shoes', 'MTV Woman Shoes'])
  end

  it '/api/v1/products?search=\'name\'' do
    create(
      :product,
      name: 'First last',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    create(:product, name: 'Second')

    get '/api/v1/products?search=First'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['First last'])
  end

  context 'search for profound words in a language other than english' do
    it '/api/v1/products?search=name&language=pl' do
      product = create(
        :product,
        name: 'First last',
        price_range: "$19.99 - $39.99",
        variants: [create(:variant, :with_variant_store)]
      )
      create(:product, name: 'Second')

      #data important for api-blueprint
      store = Store.find_by(name: 'Amazon')
      store ||= create(:store, name: 'Amazon')
      variant = create(:variant, product_id: product.id)
      create(:variant_store, variant_id: variant.id, store_id: store.id)

      get '/api/v1/products?search=First'
      body = ActiveSupport::JSON.decode(response.body)
      expect(body.map { |h| h['name'] }).to eq(['First last'])
    end
  end

  it '/api/v1/products?product_ids[]=1&product_ids[]=2' do
    product = create(
      :product,
      name: 'Selected product 1',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    product2 = create(
      :product,
      name: 'Selected product 2',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    create(:product, name: 'Other product')

    get "/api/v1/products", { product_ids: [product.id, product2.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(
      ['Selected product 1', 'Selected product 2']
    )
  end

  it '/api/v1/products/:id' do
    product = create(
      :product,
      :with_product_file_urls,
      name: 'Woman Shoes',
      price_range: "$19.99 - $39.99"
    )

    #data important for api-blueprint
    store = create(:store, name: 'Amazon')
    store2 = create(:store, name: 'Manual')
    variant = create(:variant, product_id: product.id)
    create(:variant_store, variant_id: variant.id, store_id: store.id, sku: '123123123')
    variant2 = create(:variant, product_id: product.id)
    create(:variant_store, variant_id: variant2.id, store_id: store2.id, sku: '123456789')
    option_type = create(:option_type, name: 'size')
    option_value = create(:option_value, option_type_id: option_type.id, name: 'S')
    option_value3 = create(:option_value, option_type_id: option_type.id, name: 'XXL')
    option_type2 = create(:option_type, name: 'colour')
    option_value2 = create(:option_value, option_type_id: option_type2.id, name: 'red')
    option_value4 = create(:option_value, option_type_id: option_type2.id, name: 'blue')
    create(:option_value_variant, variant_id: variant.id, option_value_id: option_value.id)
    create(:option_value_variant, variant_id: variant.id, option_value_id: option_value2.id)
    create(:option_value_variant, variant_id: variant2.id, option_value_id: option_value3.id)
    create(:option_value_variant, variant_id: variant2.id, option_value_id: option_value4.id)
    create(:variant_file,
      small_version_url: 'http://small_image.jpg',
      normal_version_url: 'http://normal_image.jpg',
      large_version_url: 'http://large_image.jpg',
      variant_id: variant.id
    )
    create(:variant_file,
      small_version_url: 'http://small.jpg',
      normal_version_url: 'http://normal.jpg',
      large_version_url: 'http://large.jpg',
      variant_id: variant2.id
    )
    woman_category = build(:category, name: 'Woman')
    create(:product_category, product: product, category: woman_category)
    similar_product = build(:product, name: 'Woman Shoes')
    create(:product_similarity, product_from: product, product_to: similar_product)

    get "/api/v1/products/#{product.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('Woman Shoes')
  end

  it '/api/v1/products/learning?page=1&per=1000' do
    image1 = create(:variant_file, normal_version_url: "http://variant_image.jpg")
    image2 = create(:variant_file, normal_version_url: "http://variant_image2.jpg")
    image3 = create(:variant_file, normal_version_url: "http://variant2_image.jpg")
    product_image = create(:product_file, normal_version_url: "http://default_image.jpg")
    variant = create(:variant, :with_variant_store, variant_files: [image1, image2])
    variant2 = create(:variant, :with_variant_store, variant_files: [image3])
    category = create(:category, name: 'shoes', parent_category: create(:category, name: "Woman"))
    product = create(
      :product,
      name: 'new product',
      categories: [category],
      variants: [variant, variant2],
      # product_files: [product_image]
    )
    product.product_files = product_image
    product.save

    create(:product, name: 'Second', categories: [category])

    get '/api/v1/products/learning?page=1&per=1000'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['new product', 'Second'])
  end

  it 'api/v1/products/learning?page=1&category_hierarchy[]=Woman&category_hierarchy[]=Jewelry&category_hierarchy[]=Tie Clips' do
    image1 = create(:variant_file, normal_version_url: "http://variant_image.jpg")
    image2 = create(:variant_file, normal_version_url: "http://variant_image2.jpg")
    image3 = create(:variant_file, normal_version_url: "http://variant2_image.jpg")
    product_image = create(:product_file, normal_version_url: "http://default_image.jpg")
    variant = create(:variant, :with_variant_store, variant_files: [image1, image2])
    variant2 = create(:variant, :with_variant_store, variant_files: [image3])
    category = create(:category, name: 'shoes', parent_category: create(:category, name: "Woman"))
    product = create(
      :product,
      name: 'new product',
      categories: [category],
      category_hierarchy: ["Woman","Jewelry","Tie Clips"],
      variants: [variant, variant2],
    # product_files: [product_image]
    )
    product.product_files = product_image
    product.save

    create(:product, name: 'Second', categories: [category], category_hierarchy: ["Woman","Jewelry","Tie Clips"])

    get '/api/v1/products/learning?page=1&per=1000', { category_hierarchy: ["Woman","Jewelry","Tie Clips"]}
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['new product', 'Second'])
  end

  it '/api/v1/products/index_shortened?search=\'name\'' do
    green_dress = create(
      :product,
      name: 'Green dress',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    blue_dress = create(
      :product,
      name: 'Blue dress',
      price_range: "$19.99 - $39.99",
      variants: [create(:variant, :with_variant_store)]
    )
    create(:product, name: 'Green hat')

    get '/api/v1/products/index_shortened?search=dress'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body).to eq(
      [
        {"id"=>blue_dress.id, "name"=>"Blue dress"},
        {"id"=>green_dress.id, "name"=>"Green dress"}
      ]
    )
  end
end

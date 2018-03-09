describe 'Channels requests' do
  it '/api/v1/channels' do
    create(:channel, name: 'MTV')
    create(:channel, name: 'Viva')

    get '/api/v1/channels'
    body = ActiveSupport::JSON.decode(response.body)
    results = body.map { |h| h['name'] }
    expect(results).to eq(['MTV', 'Viva'])
  end

  it '/api/v1/channels with following flag' do
    channel = create(:channel, name: 'MTV')
    create(:channel, name: 'Viva')
    user = create(:user, :with_token)
    new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
    create(:following, user: user, followed_type: 'Channel', followed_id: channel.id)

    get '/api/v1/channels', {}, new_auth_header
    body = ActiveSupport::JSON.decode(response.body)
    results = body.map { |h| h['name'] }
    expect(results).to eq(['MTV', 'Viva'])
    expect(body.map { |h| h['is_followed'] }).to eq([true, false])
  end

  it '/api/v1/channels with following flag wrong token' do
    channel = create(:channel, name: 'MTV')
    create(:channel, name: 'Viva')
    user = create(:user, :with_token)
    create(:following, user: user, followed_type: 'Channel', followed_id: channel.id)

    get '/api/v1/channels', {}, {
        "access-token"=>"zfyZOdltUvnvZK1Gw",
        "token-type"=>"Bearer",
        "client"=>"EDy68nOY54fJeemrNunitQ",
        "expiry"=>"1463745453",
        "uid"=>"sylvester@schmidt.org"}
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['errors']).to eq(["Authorized users only."])
  end

  it '/api/v1/channels/:id' do
    channel = create(:channel, name: 'MTV')

    get "/api/v1/channels/#{channel.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('MTV')
  end

  it '/api/v1/channels?category_id=1' do
    product = create :product
    category = create :category
    channel = create :channel
    channel2 = create :channel
    products_container = create :products_container, channel_id: channel.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: channel
    create :tag, product_id: product.id, media_container_id: media_container.id
    media_container2 = create :media_container, owner: channel2
    create :tag, product_id: product.id, media_container_id: media_container2.id
    create :product_category, product_id: product.id, category_id: category.id

    get "/api/v1/channels?category_id=#{category.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['id'] }).to eq([channel.id, channel2.id])
  end

  it '/api/v1/channels/:id/feed?number_of_posts=25&timestamp=1781096123' do
    owner = create(:media_owner)
    channel = create(:channel, media_owners: [owner])
    facebook = create(:facebook_source, source_owner: channel)
    instagram = create(:instagram_source, source_owner: owner)
    twitter = create(:twitter_source, source_owner: owner)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)
    create(:image_post, source: twitter)
    create(:video_post, source: twitter)

    get "/api/v1/channels/#{channel.id}/feed?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(6)
  end

  it '/api/v1/channels/:id/videos?number_of_posts=25&timestamp=1781096123' do
    owner = create(:media_owner)
    channel = create(:channel, media_owners: [owner])
    facebook = create(:facebook_source, source_owner: channel)
    instagram = create(:instagram_source, source_owner: owner)
    twitter = create(:twitter_source, source_owner: owner)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)
    create(:image_post, source: twitter)
    create(:video_post, source: twitter)
    create(:media_container, :with_video, owner: channel)

    get "/api/v1/channels/#{channel.id}/videos?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(3)
    expect(body['media_containers'].length).to eq(1)
  end

  it '/api/v1/channels/discovery?number_of_posts=25&timestamp=1781096123' do
    owner = create(:media_owner)
    channel1 = create(:channel, media_owners: [owner])
    channel2 = create(:channel)
    facebook = create(:facebook_source, source_owner: owner)
    instagram = create(:instagram_source, source_owner: channel1)
    twitter = create(:twitter_source, source_owner: channel2)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)
    create(:image_post, source: twitter)
    create(:video_post, source: twitter)

    get "/api/v1/channels/discovery?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(6)
  end

  it '/api/v1/channels/1/trending' do
    channel = create(:channel)
    trending = create(:trending, channel_id: channel.id)

    #data important for api-blueprint
    #relations and position
    create(
      :trending_content,
      trending: trending,
      content: build(
        :collections_container,
        name: 'collections',
        collections: [build(:collection)]
      ),
      position: 2,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :events_container,
        name: 'events container',
        events: [build(:event)]
      ),
      position: 8,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :products_container,
        name: 'products container',
        products: [build(:product)],
      ),
      position: 1,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :media_container,
        name: 'media container',
        media_content: build(:media_content, :with_file_type_image),
        owner: build(:media_owner)
      ),
      position: 3,
      width: 'half'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :media_container,
        name: 'media container',
        media_content: build(:media_content, :with_file_type_image),
        owner: build(:channel)
      ),
      position: 11,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :products_container,
        name: 'combo container',
        products: [build(:product)],
        media_content: build(:media_content),
        media_owner: build(:media_owner)
      ),
      position: 4,
      width: 'half'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :product,
        name: 'Name of the Product'
      ),
      position: 5,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: build(
        :product,
        name: 'Another Product Name'
      ),
      position: 10,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: create(
        :link,
        target: build(
          :media_owner,
          name: 'Celebrity Name'
        )
      ),
      position: 6,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: create(
        :link,
        target: build(
          :magazine,
          :with_cover_image,
          title: 'Magazine title'
        )
      ),
      position: 8,
      width: 'half'
    )
    create(
      :trending_content,
      trending: trending,
      content: create(
        :link,
        target: create(
          :tv_show,
          :with_cover_image,
          :with_1_season_2_episodes,
          title: 'Tv Show title'
        )
      ),
      position: 9,
      width: 'full'
    )
    create(
      :trending_content,
      trending: trending,
      content: create(
        :link,
        target: create(
          :event,
          name: 'Event Super Name'
        )
      ),
      position: 12,
      width: 'full'
    )

    get "/api/v1/channels/#{channel.id}/trending"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.count).to eq(7)
    expect(body['products_containers'][0]['name']).to eq('products container')
    expect(body['events_containers'][0]['name']).to eq('events container')
    expect(body['collections_containers'][0]['name']).to eq('collections')
    expect(body['media_containers'][0]['name']).to eq('media container')
    expect(body['combo_containers'][0]['name']).to eq('combo container')
    expect(body['single_product_containers'][0]['name']).to eq('Name of the Product')
    expect(body['links_containers'][0]['name']).to eq('Celebrity Name')
    expect(body['links_containers'][1]['name']).to eq('Magazine title')
    expect(body['links_containers'][2]['name']).to eq('Tv Show title')
    expect(body['links_containers'][3]['name']).to eq('Event Super Name')
  end
end

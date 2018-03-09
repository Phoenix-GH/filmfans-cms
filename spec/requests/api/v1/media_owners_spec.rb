describe 'MediaOwners requests' do
  it '/api/v1/media_owners' do
    create(:media_owner, name: 'Jennifer Lopez')
    create(:media_owner, name: 'Chrissy Teigen')

    get '/api/v1/media_owners'
    body = ActiveSupport::JSON.decode(response.body)
    results = body.map { |h| h['name'] }
    expect(results).to eq(['Jennifer Lopez', 'Chrissy Teigen'])
  end

  it '/api/v1/media_owners with following flag' do
    media_owner = create(:media_owner, name: 'Jennifer Lopez')
    create(:media_owner, name: 'Chrissy Teigen')
    user = create(:user, :with_token)
    new_auth_header = user.create_new_auth_token(user.tokens.keys[0])
    create(:following, user: user, followed_type: 'MediaOwner', followed_id: media_owner.id)

    get '/api/v1/media_owners', {}, new_auth_header
    body = ActiveSupport::JSON.decode(response.body)
    results = body.map { |h| h['name'] }
    expect(results).to eq(['Jennifer Lopez', 'Chrissy Teigen'])
    expect(body.map { |h| h['is_followed'] }).to eq([true, false])
  end

  it '/api/v1/channels with following flag wrong token' do
    media_owner = create(:media_owner, name: 'Jennifer Lopez')
    create(:media_owner, name: 'Chrissy Teigen')
    user = create(:user, :with_token)
    create(:following, user: user, followed_type: 'MediaOwner', followed_id: media_owner.id)

    get '/api/v1/media_owners', {}, {
        "access-token"=>"zfyZOdltUvnvZK1Gw",
        "token-type"=>"Bearer",
        "client"=>"EDy68nOY54fJeemrNunitQ",
        "expiry"=>"1463745453",
        "uid"=>"sylvester@schmidt.org"}
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['errors']).to eq(["Authorized users only."])
  end

  it '/api/v1/media_owners?sort=followings' do
    owner1 = create(:media_owner, name: 'Jennifer Lopez')
    create(:media_owner, name: 'Chrissy Teigen')
    create(:following, followed_id: owner1.id, followed_type: 'MediaOwner')

    get '/api/v1/media_owners?sort=followings'
    body = ActiveSupport::JSON.decode(response.body)
    results = body.map { |h| h['name'] }
    expect(results).to eq(['Jennifer Lopez', 'Chrissy Teigen'])
  end

  it '/api/v1/media_owners/:id' do
    media_owner = create(:media_owner, name: 'Jennifer Lopez')
    channel = create(:channel)
    create(:channel_media_owner, channel: channel, media_owner: media_owner)
    get "/api/v1/media_owners/#{media_owner.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['name']).to eq('Jennifer Lopez')
  end

  it '/api/v1/media_owners?category_id=1' do
    product = create :product
    category = create :category
    media_owner = create :media_owner
    media_owner2 = create :media_owner
    products_container = create :products_container, media_owner_id: media_owner.id
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    media_container = create :media_container, owner: media_owner
    create :tag, product_id: product.id, media_container_id: media_container.id
    media_container2 = create :media_container, owner: media_owner2
    create :tag, product_id: product.id, media_container_id: media_container2.id
    create :product_category, product_id: product.id, category_id: category.id

    get "/api/v1/media_owners?category_id=#{category.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['id'] }).to eq([media_owner.id, media_owner2.id])
  end

  it '/api/v1/media_owners?search=\'name\'' do
    create(:media_owner, name: 'Jennifer Lopez')
    create(:media_owner, name: 'Chrissy Teigen')

    get '/api/v1/media_owners?search=Jennifer'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['Jennifer Lopez'])
  end

  it '/api/v1/media_owners?channel_id[]=1' do
    channel = create(:channel)
    owner = create(:media_owner, name: 'with channel')
    owner2 = create(:media_owner, name: 'with channel2')
    other = create(:media_owner, name: 'with other channel')
    create(:media_owner, name: 'without channel')
    create(:channel_media_owner, media_owner: owner, channel: channel)
    create(:channel_media_owner, media_owner: owner2, channel: channel)
    create(:channel_media_owner, media_owner: other, channel: create(:channel))

    get "/api/v1/media_owners", { channel_id: [channel.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.map { |h| h['name'] }).to eq(['with channel', 'with channel2'])
  end

  it '/api/v1/media_owners/:id/feed?number_of_posts=25&timestamp=1781096123' do
    owner = create(:media_owner)
    facebook = create(:facebook_source, source_owner: owner)
    instagram = create(:instagram_source, source_owner: owner)
    twitter = create(:twitter_source, source_owner: owner)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)
    create(:image_post, source: twitter)
    create(:video_post, source: twitter)

    get "/api/v1/media_owners/#{owner.id}/feed?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(6)
  end

  it '/api/v1/media_owners/:id/videos?number_of_posts=25&timestamp=1781096123' do
    owner = create(:media_owner)
    facebook = create(:facebook_source, source_owner: owner)
    instagram = create(:instagram_source, source_owner: owner)
    twitter = create(:twitter_source, source_owner: owner)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)
    create(:image_post, source: twitter)
    create(:video_post, source: twitter)
    create(:media_container, :with_video, owner: owner)

    get "/api/v1/media_owners/#{owner.id}/videos?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(3)
    expect(body['media_containers'].length).to eq(1)
  end

  it '/api/v1/media_owners/discovery?number_of_posts=25&timestamp=1781096123' do
    owner1 = create(:media_owner)
    owner2 = create(:media_owner)
    facebook = create(:facebook_source, source_owner: owner1)
    instagram = create(:instagram_source, source_owner: owner2)
    create(:image_post, source: facebook)
    create(:video_post, source: facebook)
    create(:image_post, source: instagram)
    create(:video_post, source: instagram)

    get "/api/v1/media_owners/discovery?number_of_posts=25&timestamp=#{Time.now.to_i}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['social_media_containers'].length).to eq(4)
  end
end

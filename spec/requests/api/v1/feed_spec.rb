describe 'Feed requests' do
  it '/api/v1/feed' do
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
    create(:products_container,
      name: 'products_container',
      media_owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )

    get '/api/v1/feed'
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['media_containers'][0]['name']).to eq('Today')
    expect(body['media_containers'][1]['name']).to eq('Yesterday')
    expect(body['combo_containers'][0]['name']).to eq('products_container')
  end

  it '/api/v1/feed?media_owner_id[]=1' do
    owner = build_stubbed(:media_owner)
    create(:media_container,
      name: 'Yesterday',
      created_at: Date.yesterday,
      owner: owner,
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:media_container,
      name: 'Today',
      created_at: Date.today,
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:products_container,
      name: 'products_container',
      media_owner: owner,
      media_content: build(:media_content, :with_file_type_image)
    )

    get "/api/v1/feed", { media_owner_id: [owner.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['media_containers'][0]['name']).to eq('Yesterday')
    expect(body['media_containers'].count).to eq(1)
    expect(body['combo_containers'][0]['name']).to eq('products_container')
  end

  it '/api/v1/feed?channel_id[]=1' do
    channel = build_stubbed(:channel)
    create(:media_container,
      name: 'Yesterday',
      created_at: Date.yesterday,
      owner: channel,
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:media_container,
      name: 'Today',
      created_at: Date.today,
      owner: build(:channel),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:products_container,
      name: 'products_container',
      channel: channel,
      media_owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )

    get "/api/v1/feed", { channel_id: [channel.id] }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['media_containers'][0]['name']).to eq('Yesterday')
    expect(body['media_containers'].count).to eq(1)
    expect(body['combo_containers'][0]['name']).to eq('products_container')
  end

  it '/api/v1/feed?with_channel=true' do
    create(:media_container,
      name: 'with channel',
      created_at: Date.yesterday,
      owner: build_stubbed(:channel),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:media_container,
      name: 'without channel',
      created_at: Date.today,
      owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:products_container,
      name: 'with channel2',
      channel: build_stubbed(:channel),
      media_owner: build(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )

    get "/api/v1/feed", { with_channel: true }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['media_containers'][0]['name']).to eq('with channel')
    expect(body['media_containers'].count).to eq(1)
    expect(body['combo_containers'][0]['name']).to eq('with channel2')
  end


  it '/api/v1/feed?with_media_owner=true' do
    create(:media_container,
      name: 'With media owner',
      created_at: Date.yesterday,
      owner: build_stubbed(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:media_container,
      name: 'without media owner',
      created_at: Date.today,
      owner: nil,
      media_content: build(:media_content, :with_file_type_image)
    )
    create(:products_container,
      name: 'with media owner',
      media_owner: build_stubbed(:media_owner),
      media_content: build(:media_content, :with_file_type_image)
    )

    get "/api/v1/feed", { with_media_owner: true }
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['media_containers'][0]['name']).to eq('With media owner')
    expect(body['media_containers'].count).to eq(1)
    expect(body['combo_containers'][0]['name']).to eq('with media owner')
  end
end

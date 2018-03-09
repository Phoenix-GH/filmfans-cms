describe 'Events requests' do
  it '/api/v1/events/:id' do
    event = create(:event, name: 'Event Name')
    #data important for api-blueprint
    product = build(
      :product,
      name: 'Name of the Product'
    )
    product2 = build(
      :product,
      name: 'Another Product Name'
    )
    products_container = build(
      :products_container,
      name: 'Name of the Product Series',
      products: build_list(:product, 2)
    )
    celebrity_link = create(
      :link,
      target: build(
        :media_owner,
        name: 'Celebrity Name'
      )
    )
    channel_link = create(
      :link,
      target: create(
        :channel,
        :with_video_container,
        name: 'Channel Name'
      )
    )
    magazine_link = create(
      :link,
      target: build(
        :magazine,
        :with_cover_image,
        title: 'Magazine title'
      )
    )
    tv_show_link = create(
      :link,
      target: create(
        :tv_show,
        :with_cover_image,
        :with_1_season_2_episodes,
        title: 'Tv Show title'
      )
    )
    celeb_media_container = build(
      :media_container,
      name: 'media container',
      media_content: build(:media_content, :with_file_type_image),
      owner: build(:media_owner)
    )
    channel_media_container = build(
      :media_container,
      name: 'media container',
      media_content: build(:media_content, :with_file_type_image),
      owner: build(:channel)
    )
    event_link = create(
      :link,
      target: create(
        :event,
        name: 'Event Super Name'
      )
    )
    collections_container = build(
      :collections_container,
      name: 'collections container'
    )

    #relations and position
    create(
      :event_content,
      event: event,
      content: celeb_media_container,
      position: 1,
      width: 'half'
    )
    create(
      :event_content,
      event: event,
      content: channel_media_container,
      position: 3,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: product,
      position: 2,
      width: 'half'
    )
    create(
      :event_content,
      event: event,
      content: product2,
      position: 4,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: products_container,
      position: 9,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: celebrity_link,
      position: 5,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: channel_link,
      position: 7,
      width: 'half'
    )
    create(
      :event_content,
      event: event,
      content: magazine_link,
      position: 8,
      width: 'half'
    )
    create(
      :event_content,
      event: event,
      content: tv_show_link,
      position: 6,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: event_link,
      position: 12,
      width: 'full'
    )
    create(
      :event_content,
      event: event,
      content: collections_container,
      position: 13,
      width: 'full'
    )

    get "/api/v1/events/#{event.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body.count).to eq(10)
    expect(body['media_containers'][0]['name']).to eq('media container')
    expect(body['single_product_containers'][0]['name']).to eq('Name of the Product')
    expect(body['products_containers'][0]['name']).to eq('Name of the Product Series')
    expect(body['links_containers'][0]['name']).to eq('Celebrity Name')
    expect(body['links_containers'][1]['name']).to eq('Channel Name')
    expect(body['links_containers'][2]['name']).to eq('Magazine title')
    expect(body['links_containers'][3]['name']).to eq('Tv Show title')
    expect(body['links_containers'][4]['name']).to eq('Event Super Name')
    expect(body['collections_containers'][0]['name']).to eq('collections container')
  end
end

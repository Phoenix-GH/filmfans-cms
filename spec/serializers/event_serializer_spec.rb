describe EventSerializer do
  it 'return' do
    event = create(:event, :with_cover_image, :with_background_image, name: 'Event name')
    media_container = create(:media_container)
    products_container = create(:products_container)
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    collections_container = create(:collections_container)
    event_content1 = create(
      :event_content,
      event: event,
      content: media_container,
      position: 1,
      width: 'half'
    )
    event_content2 = create(
      :event_content,
      event: event,
      content: product,
      position: 2,
      width: 'half'
    )
    event_content3 = create(
      :event_content,
      event: event,
      content: link,
      position: 3,
      width: 'half'
    )
    event_content4 = create(
      :event_content,
      event: event,
      content: products_container,
      position: 4,
      width: 'full'
    )
    event_content5 = create(
      :event_content,
      event: event,
      content: collections_container,
      position: 5,
      width: 'full'
    )

    results = EventSerializer.new(event, with_content: true).results

    expect(results).to eq(
      id: event.id,
      name: 'Event name',
      type: 'event_container',
      image_url: event.background_image.custom_url,
      cover_image_url: event.cover_image.custom_url,
      media_containers: [
        MediaContainerSerializer.new(
          media_container
        ).results.merge(position: event_content1.position, width: event_content1.width)
      ],
      products_containers: [
        ProductsContainerSerializer.new(
          products_container
        ).results.merge(position: event_content4.position, width: event_content4.width)
      ],
      single_product_containers: [
        ProductSerializer.new(
          product
        ).results.merge(position: event_content2.position, width: event_content2.width)
      ],
      links_containers: [
        LinkSerializer.new(
          link
        ).results.merge(position: event_content3.position, width: event_content3.width)
      ],
      collections_containers: [
        CollectionsContainerSerializer.new(
          collections_container
        ).results.merge(position: event_content5.position, width: event_content5.width)
      ]
    )
  end

  it 'missing values' do
    event = build(:event, name: nil)
    results = EventSerializer.new(event).results
    expect(results).to eq(
      id: 0,
      name: '',
      type: 'event_container',
      image_url: '',
      cover_image_url: '',
      media_containers: [],
      products_containers: [],
      single_product_containers: [],
      links_containers: [],
      collections_containers: []
    )
  end

  it 'removed contents' do
    event = create(:event, :with_cover_image, :with_background_image, name: 'Event name')
    media_container = create(:media_container)
    products_container = create(:products_container)
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    collections_container = create(:collections_container)

    create(:event_content, event: event, content: media_container, position: 1, width: 'half')
    create(:event_content, event: event, content: product, position: 2, width: 'half')
    create(:event_content, event: event, content: link, position: 3, width: 'half')
    create(:event_content, event: event, content: products_container, position: 4, width: 'full')
    create(:event_content, event: event, content: collections_container, position: 5, width: 'full')

    media_container.destroy
    products_container.destroy
    product.destroy
    link.destroy
    collections_container.destroy

    results = EventSerializer.new(event).results
    expect(results).to eq(
      id: event.id,
      name: event.name,
      type: 'event_container',
      image_url: event.background_image.custom_url,
      cover_image_url: event.cover_image.custom_url,
      media_containers: [],
      products_containers: [],
      single_product_containers: [],
      links_containers: [],
      collections_containers: []
    )
  end
end

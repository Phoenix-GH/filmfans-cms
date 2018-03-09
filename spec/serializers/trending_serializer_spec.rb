describe TrendingSerializer do
  it 'return' do
    trending = create(:trending)
    collections_container = create(:collections_container)
    events_container = create(:events_container)
    products_container = create(:products_container)
    media_container = create(:media_container)
    combo_container = create(
      :products_container,
      products: [build(:product)],
      media_content: build(:media_content),
      media_owner: build(:media_owner)
    )
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    event_link = create(:link, target: create(:event))
    collections_container_content = create(
      :trending_content,
      trending: trending,
      content: collections_container,
      position: 2,
      width: 'full'
    )
    products_container_content = create(
      :trending_content,
      trending: trending,
      content: products_container,
      position: 1
    )
    media_container_content = create(
      :trending_content,
      trending: trending,
      content: media_container,
      position: 3,
      width: 'half'
    )
    combo_container_content = create(
      :trending_content,
      trending: trending,
      content: combo_container,
      position: 4,
      width: 'half'
    )
    product_content = create(
      :trending_content,
      trending: trending,
      content: product,
      position: 5,
      width: 'half'
    )
    link_content = create(
      :trending_content,
      trending: trending,
      content: link,
      position: 6,
      width: 'half'
    )
    event_link_content = create(
      :trending_content,
      trending: trending,
      content: event_link,
      position: 7
    )
    events_container_content = create(
      :trending_content,
      trending: trending,
      content: events_container,
      position: 8,
      width: 'full'
    )

    results = TrendingSerializer.new(trending).results

    expect(results).to eq(
      collections_containers:[
        CollectionsContainerSerializer.new(
          collections_container
        ).results.merge(position: collections_container_content.position, width: 'full')
      ],
      events_containers:[
        EventsContainerSerializer.new(
          events_container
        ).results.merge(position: events_container_content.position, width: 'full')
      ],
      products_containers: [
        ProductsContainerSerializer.new(
          products_container
        ).results.merge(position: products_container_content.position, width: 'full')
      ],
      media_containers: [
        MediaContainerSerializer.new(
          media_container
        ).results.merge(position: media_container_content.position, width: 'half')
      ],
      combo_containers: [
        ProductsContainerSerializer.new(
          combo_container
        ).results.merge(position: combo_container_content.position, width: 'half')
      ],
      single_product_containers: [
        ProductSerializer.new(
          product
        ).results.merge(position: product_content.position, width: 'half')
      ],
      links_containers: [
        LinkSerializer.new(
          link
        ).results.merge(position: link_content.position, width: 'half'),
        LinkSerializer.new(
          event_link
        ).results.merge(position: event_link_content.position, width: 'full')
      ]
    )
  end

  it 'missing values' do
    trending = build(:trending)
    results = TrendingSerializer.new(trending).results
    expect(results).to eq(
      collections_containers: [],
      events_containers: [],
      products_containers: [],
      media_containers: [],
      combo_containers: [],
      single_product_containers: [],
      links_containers: []
    )
  end

  it 'removed_contents' do
    trending = create(:trending)
    collections_container = create(:collections_container)
    events_container = create(:events_container)
    products_container = create(:products_container)
    media_container = create(:media_container)
    combo_container = create(
        :products_container,
        products: [build(:product)],
        media_content: build(:media_content),
        media_owner: build(:media_owner)
    )
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    event_link = create(:link, target: create(:event))

    create(:trending_content, trending: trending, content: collections_container, position: 2, width: 'full')
    create(:trending_content, trending: trending, content: products_container, position: 1)
    create(:trending_content, trending: trending, content: media_container, position: 3, width: 'half')
    create(:trending_content, trending: trending, content: combo_container, position: 4, width: 'half')
    create(:trending_content, trending: trending, content: product, position: 5, width: 'half')
    create(:trending_content, trending: trending, content: link, position: 6, width: 'half')
    create(:trending_content, trending: trending, content: event_link, position: 7)
    create(:trending_content, trending: trending, content: events_container, position: 8, width: 'full')

    collections_container.destroy
    events_container.destroy
    products_container.destroy
    media_container.destroy
    combo_container.destroy
    product.destroy
    link.destroy
    event_link.destroy

    results = TrendingSerializer.new(trending).results

    expect(results).to eq(
      collections_containers: [],
      events_containers: [],
      products_containers: [],
      media_containers: [],
      combo_containers: [],
      single_product_containers: [],
      links_containers: []
    )
  end
end

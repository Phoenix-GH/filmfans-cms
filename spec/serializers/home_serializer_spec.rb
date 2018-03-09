describe HomeSerializer do
  it 'return' do
    home = create(:home)
    collections_container = create(:collections_container)
    products_container = create(:products_container)
    events_container = create(
      :events_container,
      channel: build(:channel)
      )
    media_container = create(:media_container)
    combo_container = create(
      :products_container,
      products: [build(:product)],
      media_content: build(:media_content),
      media_owner: build(:media_owner)
    )
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    magazine_link = create(:link, target: create(:magazine))
    home_content = create(
      :home_content,
      home: home,
      content: collections_container,
      position: 2,
      width: 'full'
    )
    home_content2 = create(
      :home_content,
      home: home,
      content: products_container,
      position: 1
    )
    home_content3 = create(
      :home_content,
      home: home,
      content: media_container,
      position: 3,
      width: 'half'
    )
    home_content4 = create(
      :home_content,
      home: home,
      content: combo_container,
      position: 4,
      width: 'half'
    )
    home_content5 = create(
      :home_content,
      home: home,
      content: product,
      position: 5,
      width: 'half'
    )
    home_content6 = create(
      :home_content,
      home: home,
      content: link,
      position: 6,
      width: 'half'
    )
    home_content7 = create(
      :home_content,
      home: home,
      content: magazine_link,
      position: 7
    )
    home_content8 = create(
      :home_content,
      home: home,
      content: events_container,
      position: 8
    )

    results = HomeSerializer.new(home).results

    expect(results).to eq(
      home_type: home.home_type,
      collections_containers:[
        CollectionsContainerSerializer.new(
          collections_container
        ).results.merge(position: home_content.position, width: 'full')
      ],
      products_containers: [
        ProductsContainerSerializer.new(
          products_container
        ).results.merge(position: home_content2.position, width: 'full')
      ],
      media_containers: [
        MediaContainerSerializer.new(
          media_container
        ).results.merge(position: home_content3.position, width: 'half')
      ],
      combo_containers: [
        ProductsContainerSerializer.new(
          combo_container
        ).results.merge(position: home_content4.position, width: 'half')
      ],
      single_product_containers: [
        ProductSerializer.new(
          product
        ).results.merge(position: home_content5.position, width: 'half')
      ],
      links_containers: [
        LinkSerializer.new(
          link
        ).results.merge(position: home_content6.position, width: 'half'),
        LinkSerializer.new(
          magazine_link
        ).results.merge(position: home_content7.position, width: 'full')
      ],
      events_containers: [
        EventsContainerSerializer.new(
          events_container
        ).results.merge(position: home_content8.position, width: 'full')
      ]
    )
  end

  it 'missing values' do
    home = build(:home, home_type: nil)
    results = HomeSerializer.new(home).results
    expect(results).to eq(
      home_type: '',
      collections_containers: [],
      products_containers: [],
      media_containers: [],
      combo_containers: [],
      single_product_containers: [],
      links_containers: [],
      events_containers: []
    )
  end

  it 'removed contents' do
    home = create(:home)
    collections_container = create(:collections_container)
    products_container = create(:products_container)
    events_container = create( :events_container, channel: build(:channel))
    media_container = create(:media_container)
    combo_container = create(
        :products_container,
        products: [build(:product)],
        media_content: build(:media_content),
        media_owner: build(:media_owner)
    )
    product = create(:product)
    link = create(:link, target: create(:media_owner))
    magazine_link = create(:link, target: create(:magazine))

    create(:home_content, home: home, content: collections_container, position: 2, width: 'full')
    create(:home_content, home: home, content: products_container, position: 1)
    create(:home_content, home: home, content: media_container, position: 3, width: 'half')
    create(:home_content, home: home, content: combo_container, position: 4, width: 'half')
    create(:home_content, home: home, content: product, position: 5, width: 'half')
    create(:home_content, home: home, content: link, position: 6, width: 'half')
    create(:home_content, home: home, content: magazine_link, position: 7)
    create(:home_content, home: home, content: events_container, position: 8)

    collections_container.destroy
    products_container.destroy
    events_container.destroy
    media_container.destroy
    combo_container.destroy
    product.destroy
    link.destroy
    magazine_link.destroy

    results = HomeSerializer.new(home).results
    expect(results).to eq(
      home_type: home.home_type,
      collections_containers: [],
      products_containers: [],
      media_containers: [],
      combo_containers: [],
      single_product_containers: [],
      links_containers: [],
      events_containers: []
    )
  end
end

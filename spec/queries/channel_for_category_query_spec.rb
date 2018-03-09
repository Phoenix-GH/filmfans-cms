describe ChannelForCategoryQuery do
  it 'find channels by category and products_containers' do
    nike_shoes = build_stubbed(:product, name: 'nike shoes')
    glass = create(:product, name: 'glass')
    shoes_category = build(:category, name: 'shoes')
    glasses_category = build(:category, name: 'glasses')
    create(:product_category, product: nike_shoes, category: shoes_category)
    create(:product_category, product: glass, category: glasses_category)

    channel = build_stubbed :channel
    channel2 = build_stubbed :channel
    other_channel = build_stubbed :channel
    create(
      :linked_product,
      product: nike_shoes,
      products_container: create(:products_container, channel: channel)
    )
    create(
      :linked_product,
      product: nike_shoes,
      products_container: create(:products_container, channel: channel2)
    )
    create(
      :linked_product,
      product: nike_shoes,
      products_container: create(:products_container, channel: nil)
    )
    create(
      :linked_product,
      product: glass,
      products_container: create(:products_container, channel: other_channel)
    )

    results = ChannelForCategoryQuery.new(shoes_category.id).results
    expect(results).to eq([channel.id, channel2.id])
  end

  it 'find channels by category and media_containers' do
    nike_shoes = build_stubbed(:product, name: 'nike shoes')
    glass = create(:product, name: 'glass')
    shoes_category = build(:category, name: 'shoes')
    glasses_category = build(:category, name: 'glasses')
    create(:product_category, product: nike_shoes, category: shoes_category)
    create(:product_category, product: glass, category: glasses_category)

    channel = build :channel
    channel2 = build :channel
    other_channel = build_stubbed :channel
    create(
      :tag,
      product: nike_shoes,
      media_container: create(:media_container, owner: channel)
    )
    create(
      :tag,
      product: nike_shoes,
      media_container: create(:media_container, owner: channel2)
    )
    create(
      :tag,
      product: nike_shoes,
      media_container: create(:media_container, owner: nil)
    )
    create(
      :tag,
      product: glass,
      media_container: create(:media_container, owner: other_channel)
    )

    results = ChannelForCategoryQuery.new(shoes_category.id).results
    expect(results).to eq([channel.id, channel2.id])
  end

  it 'without duplicate' do
    product = create(:product)
    category = build(:category)
    create(:product_category, product: product, category: category)

    channel = build_stubbed :channel
    create(
      :tag,
      product: product,
      media_container: create(:media_container, owner: channel)
    )
    create(
      :linked_product,
      product: product,
      products_container: create(:products_container, channel: channel)
    )

    results = ChannelForCategoryQuery.new(category.id).results
    expect(results).to eq([channel.id])
  end
end

describe FeedSerializer do
  it 'return' do
    media_container = create(:media_container)
    products_container = create(:products_container)

    results = FeedSerializer.new([media_container, products_container]).results
    expect(results).to eq({
      combo_containers: [ProductsContainerSerializer.new(products_container).results.merge(position: 2)],
      media_containers: [MediaContainerSerializer.new(media_container).results.merge(position: 1)]
    })
  end

  it 'missing values' do
    results = FeedSerializer.new([]).results
    expect(results).to eq({
      combo_containers: [],
      media_containers: []
    })
  end
end

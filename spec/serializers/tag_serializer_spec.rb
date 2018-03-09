describe TagSerializer do
  it 'return' do
    product = create(:product, :with_media_content)
    category = create(:category, :with_icon)
    create(:product_category, category: category, product: product)
    tag = build(
      :tag,
      coordinate_x: 0.5,
      coordinate_y: 0.5,
      coordinate_duration_start: 3455,
      coordinate_duration_end: 4212,
      product: product
    )
    results = TagSerializer.new(tag).results

    expect(results).to eq(
      {
        id: tag.id,
        icon: category.icon.url,
        coordinate_x: '0.500',
        coordinate_y: '0.500',
        start_time_ms: 3455,
        end_time_ms: 4212,
        product: ProductSerializer.new(
          product,
          with_similar_products: false
        ).results
      }
    )
  end

  it 'missing values' do
    tag = build(
      :tag,
      coordinate_x: nil,
      coordinate_y: nil,
      coordinate_duration_start: nil,
      coordinate_duration_end: nil
    )
    results = TagSerializer.new(tag).results
    expect(results).to eq(
      {
        id: tag.id,
        icon: '',
        coordinate_x: '',
        coordinate_y: '',
        start_time_ms: nil,
        end_time_ms: nil,
        product: ''
      }
    )
  end
end

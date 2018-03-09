describe VariantSerializer do
  it 'return' do
    store = create(:store, name: 'Store')
    variant = create(:variant, :with_variant_file_urls, description: 'description')
    option_type = create(:option_type, name: 'size')
    option_value = create(:option_value, option_type_id: option_type.id, name: 'S')
    option_type2 = create(:option_type, name: 'colour')
    option_value2 = create(:option_value, option_type_id: option_type2.id, name: 'red')
    create(:option_value_variant, variant_id: variant.id, option_value_id: option_value.id)
    create(:option_value_variant, variant_id: variant.id, option_value_id: option_value2.id)
    create(:variant_store,
      price: 122.22,
      sku: '123123123',
      currency: 'PLN',
      url: 'www.zalando.com/variants/beret',
      store_id: store.id,
      variant_id: variant.id,
      quantity: 99
    )
    results = VariantSerializer.new(variant).results

    expect(results).to eq(
      {
        id: variant.id,
        sku: '123123123',
        description: 'description',
        variant_files:[
          image: 'http://large_image.jpg',
          small_image: 'http://small_image.jpg',
          medium_image: 'http://normal_image.jpg'
        ],
        variant_stores: [
          value: '122.22',
          currency: 'PLN',
          url: 'www.zalando.com/variants/beret',
          quantity: '99',
          store: 'Store'
        ],
        option_values: [
          {
            value: 'S',
            option_type: 'size'
          },
          {
            value: 'red',
            option_type: 'colour'
          }
        ]
      }
    )
  end

  it 'missing values' do
    variant = create(:variant, description: nil)
    results = VariantSerializer.new(variant).results
    expect(results).to eq(
      {
        id: variant.id,
        sku: '',
        description: '',
        variant_files: [],
        variant_stores: [],
        option_values: []
      }
    )
  end
end

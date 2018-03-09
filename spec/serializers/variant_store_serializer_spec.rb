describe VariantStoreSerializer do
  it 'return' do
    store = create(:store, name: 'Store')
    variant_store = create(:variant_store,
      price: 122.22,
      currency: 'PLN',
      url: 'www.zalando.com/variants/beret',
      quantity: 99,
      store_id: store.id
    )
    results = VariantStoreSerializer.new(variant_store).results

    expect(results).to eq(
      {
        value: '122.22',
        currency: 'PLN',
        url: 'www.zalando.com/variants/beret',
        quantity: '99',
        store: 'Store'
      }
    )
  end

  it 'missing values' do
    variant_store = build(:variant_store,
      price: nil,
      currency: nil,
      url: nil,
      quantity: nil
    )
    results = VariantStoreSerializer.new(variant_store).results
    expect(results).to eq(
      {
        value: '',
        currency: '',
        url: '',
        quantity: '',
        store: ''
      }
    )
  end
end

describe Panel::CreateVariantStoreService do
  it 'call' do
    variant = build_stubbed :variant
    variant_store_attributes = {
      currency: 'EUR',
      price: '2.90',
      url: 'url'
    }
    form = double(
      valid?: true,
      attributes: variant_store_attributes
    )

    service = Panel::CreateVariantStoreService.new(variant, form)
    expect { service.call }.to change { VariantStore.count }.by(1)
  end

  context 'form invalid' do
    it 'returns false' do
      variant = build_stubbed :variant
      variant_store_attributes = {
        currency: 'EUR',
        price: '2.90',
        url: ''
      }
      form = double(
        valid?: false,
        attributes: variant_store_attributes
      )

      service = Panel::CreateVariantStoreService.new(variant, form)
      expect(service.call).to eq(false)
      expect { service.call }.to change { VariantStore.count }.by(0)
    end
  end
end

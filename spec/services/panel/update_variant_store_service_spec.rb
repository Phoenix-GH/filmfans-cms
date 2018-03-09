describe Panel::UpdateVariantStoreService do
  it 'call' do
    variant_store = create :variant_store, url: 'Old url'
    form = double(
      valid?: true,
      attributes: { url: 'New url' }
    )

    service = Panel::UpdateVariantStoreService.new(variant_store, form)
    expect(service.call).to eq(true)
    expect(variant_store.reload.url).to eq 'New url'
  end

  context 'form invalid' do
    it 'returns false' do
      variant_store = create :variant_store, url: 'Old url'
      form = double(
        valid?: false,
        attributes: { url: '' }
      )

      service = Panel::UpdateVariantStoreService.new(variant_store, form)
      expect(service.call).to eq(false)
      expect(variant_store.reload.url).to eq 'Old url'
    end
  end
end

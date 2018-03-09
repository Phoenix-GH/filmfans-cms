describe Panel::UpdateVariantStoreForm do
  it 'valid' do
    variant_store_attributes = {
      currency: 'EUR',
      price: '2.95',
      url: 'url'
    }

    form = Panel::UpdateVariantStoreForm.new(
      variant_store_attributes,
      { url: 'New Url' }
    )

    expect(form.valid?).to eq true
    expect(form.url).to eq 'New Url'
  end

  context 'invalid' do
    it 'currency' do
      variant_store_attributes = {
        currency: 'EUR',
        price: 'foo',
        url: 'url'
      }
      form = Panel::UpdateVariantStoreForm.new(
        variant_store_attributes,
        { currency: '' }
      )

      expect(form.valid?).to eq false
    end

    it 'price' do
      variant_store_attributes = {
        currency: 'EUR',
        price: 'foo',
        url: 'url'
      }
      form = Panel::UpdateVariantStoreForm.new(
        variant_store_attributes,
        { price: 'foo' }
      )

      expect(form.valid?).to eq false
    end
  end
end

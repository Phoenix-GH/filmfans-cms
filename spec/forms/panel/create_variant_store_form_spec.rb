describe Panel::CreateVariantStoreForm do
  it 'valid' do
    variant_store_form_params = {
      currency: 'EUR',
      price: '2.90',
      url: 'url'
    }
    form = Panel::CreateVariantStoreForm.new(variant_store_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'currency' do
      variant_store_form_params = {
        currency: '',
        price: '2.90',
        url: 'url'
      }
      form = Panel::CreateVariantStoreForm.new(variant_store_form_params)

      expect(form.valid?).to eq false
    end

    it 'price' do
      variant_store_form_params =
      {
        currency: 'EUR',
        price: 'foo',
        url: 'url'
      }
      form = Panel::CreateVariantStoreForm.new(variant_store_form_params)

      expect(form.valid?).to eq false
    end
  end
end

describe Panel::Wizards::CreateProductForm do
  it 'valid' do
    product_form_params = {
      name: 'name',
      brand: 'brand',
      shipping_info: 'shipping_info',
      vendor_url: 'vendor_url',
      category_ids: [21, 22]
    }
    form = Panel::Wizards::CreateProductForm.new(product_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      product_form_params = {
        name: '',
        brand: 'brand',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        category_ids: [21, 22]
      }
      form = Panel::Wizards::CreateProductForm.new(product_form_params)

      expect(form.valid?).to eq false
    end

    it 'brand: presence' do
      product_form_params = {
        name: 'name',
        brand: '',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        category_ids: [21, 22]
      }
      form = Panel::Wizards::CreateProductForm.new(product_form_params)

      expect(form.valid?).to eq false
    end

    it 'category_ids: presence' do
      product_form_params = {
        name: 'name',
        brand: 'brand',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        category_ids: []
      }
      form = Panel::Wizards::CreateProductForm.new(product_form_params)

      expect(form.valid?).to eq false
    end

    it 'name: uniqueness' do
      create :product, name: 'NAME'

      product_form_params = {
        name: 'Name',
        brand: 'brand',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        category_ids: [21, 22]
      }
      form = Panel::Wizards::CreateProductForm.new(product_form_params)

      expect(form.valid?).to eq false
    end
  end

end

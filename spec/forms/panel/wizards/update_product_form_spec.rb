describe Panel::Wizards::UpdateProductForm do

  it 'valid' do
    product_attributes = {
      id: 1,
      name: 'name',
      brand: 'brand',
      shipping_info: 'shipping_info',
      vendor_url: 'vendor_url',
      containers_placement: true,
      category_ids: [21, 22]
    }
    product_form_params = { name: 'New Name' }

    form = Panel::Wizards::UpdateProductForm.new(
      product_attributes,
      product_form_params
    )

    expect(form.valid?).to eq true
  end

  it 'valid: the old name is kept' do
    create :product, id: 9876, name: 'Name'
    product_attributes = {
      id: 9876,
      name: 'Name',
      brand: 'brand',
      shipping_info: 'shipping_info',
      vendor_url: 'vendor_url',
      containers_placement: true,
      category_ids: [21, 22]
    }
    product_form_params = { id: 9876, name: 'Name' }

    form = Panel::Wizards::UpdateProductForm.new(
      product_attributes,
      product_form_params
    )

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    let(:product_attributes) {
      {
        id: 1,
        name: 'name',
        brand: 'brand',
        shipping_info: 'shipping_info',
        vendor_url: 'vendor_url',
        containers_placement: true,
        category_ids: [21, 22]
      }
    }

    it 'name: presence' do
      product_form_params = { name: '' }

      form = Panel::Wizards::UpdateProductForm.new(
        product_attributes,
        product_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'brand: presence' do
      product_form_params = { brand: '' }

      form = Panel::Wizards::UpdateProductForm.new(
        product_attributes,
        product_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'category_ids: presence' do
      product_form_params = { category_ids: [] }

      form = Panel::Wizards::UpdateProductForm.new(
        product_attributes,
        product_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'name: uniqueness' do
      create :product, name: 'Name'
      product_form_params = { name: 'Name ' }

      form = Panel::Wizards::UpdateProductForm.new(
        product_attributes,
        product_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end

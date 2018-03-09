describe Panel::CreateProductsContainerForm do
  it 'valid' do
    products_container_form_params = {
      name: 'Old Name',
      description: 'description',
      linked_products_attributes: {1 => { product_id: 1, products_container_id: 1, _destroy: 'false' }}
    }

    form = Panel::CreateProductsContainerForm.new(products_container_form_params)

    expect(form.valid?).to eq true
  end

  it 'valid with media_owner' do
    media_content = create(:media_content)
    products_container_form_params = {
      name: 'Old Name',
      description: 'description',
      product_ids: 1,
      linked_products_attributes: {1 => { product_id: 1, products_container_id: 1, _destroy: 'false' }},
      media_content_id: media_content.id
    }

    form = Panel::CreateProductsContainerForm.new(products_container_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      products_container_form_params = {
        name: '',
        description: 'description',
        linked_products_attributes: {1 => { product_id: 1, products_container_id: 1, _destroy: 'false' }}
      }

      form = Panel::CreateProductsContainerForm.new(products_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'product linked_product_attributes' do
      products_container_form_params = {
        name: 'Old Name',
        description: 'description',
        linked_products_attributes: []
      }

      form = Panel::CreateProductsContainerForm.new(products_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'media_content_id if celebrity_id presencs' do
      products_container_form_params = {
        name: 'Old Name',
        description: 'description',
        linked_products_attributes: {1 => { product_id: 1, products_container_id: 1, _destroy: 'false' }},
        media_owner_id: 1
      }

      form = Panel::CreateProductsContainerForm.new(products_container_form_params)

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq [_('First upload file. Allowed formats: image or video')]
    end

  end
end

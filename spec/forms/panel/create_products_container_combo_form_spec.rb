describe Panel::CreateProductsContainerComboForm do
  it 'valid' do
    products_container_form_params = {
      name: 'Old Name',
      description: 'description',
      product_ids: 1
    }

    form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)

    expect(form.valid?).to eq true
  end

  it 'valid with media_owner' do
    media_content = create(:media_content)
    products_container_form_params = {
      name: 'Old Name',
      description: 'description',
      product_ids: 1,
      media_owner_id: 1,
      media_content_id: media_content.id
    }

    form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      products_container_form_params = {
        name: '',
        description: 'description',
        product_ids: 1
      }

      form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'product ids' do
      products_container_form_params = {
        name: 'Old Name',
        description: 'description',
        product_ids: ''
      }

      form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'media_content_id if celebrity_id presencs' do
      products_container_form_params = {
        name: 'Old Name',
        description: 'description',
        product_ids: 1,
        media_owner_id: 1
      }

      form = Panel::CreateProductsContainerComboForm.new(products_container_form_params)

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq [_('First upload file. Allowed formats: image or video')]
    end

  end
end

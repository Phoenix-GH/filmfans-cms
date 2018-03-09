describe Panel::UpdateProductsContainerComboForm do
  it 'valid' do
    products_container_attributes = {
      name: 'Old Name',
      description: 'old description',
      product_ids: 1
    }
    products_container_form_params = {
      name: 'New Name',
      description: 'new description',
      product_ids: [1,2]
    }

    form = Panel::UpdateProductsContainerComboForm.new(
      products_container_attributes,
      products_container_form_params
    )

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
    expect(form.description).to eq 'new description'
  end

  context 'invalid' do
    it 'name' do
      products_container_attributes = {
        name: 'Old Name',
        description: 'old description',
        product_ids: 1
      }
      products_container_form_params = {
        name: '',
        description: 'old description',
        product_ids: 2
      }

      form = Panel::UpdateProductsContainerComboForm.new(
        products_container_attributes,
        products_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'product ids' do
      products_container_attributes = {
        name: 'Old Name',
        description: 'old description',
        product_ids: 1
      }
      products_container_form_params = {
        name: 'Old Name',
        description: 'old description',
        product_ids: ''
      }

      form = Panel::UpdateProductsContainerComboForm.new(
        products_container_attributes,
        products_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'media_content_id if celebrity_id presencs' do
      media_content = create(:media_content)
      products_container_attributes = {
        name: 'Old Name',
        description: 'old description',
        product_ids: 1,
        media_owner_id: 1,
        media_content_id: media_content.id
      }
      products_container_form_params = {
        name: 'Old Name',
        description: 'old description',
        product_ids: 1,
        media_owner_id: 1,
        media_content_id: nil
      }

      form = Panel::UpdateProductsContainerComboForm.new(
        products_container_attributes,
        products_container_form_params
      )

      expect(form.valid?).to eq false
      expect(form.errors.full_messages).to eq ["First upload file. Allowed formats: image or video"]

    end

  end
end

describe Panel::CreateCollectionsContainerForm do
  it 'valid' do
    collections_container_form_params = {
      name: 'Old Name',
      linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1}}
    }

    form = Panel::CreateCollectionsContainerForm.new(collections_container_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      collections_container_form_params = {
        name: '',
        linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1}}
      }

      form = Panel::CreateCollectionsContainerForm.new(collections_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'linked_collections' do
      collections_container_form_params = {
        name: 'Old Name',
        collection_ids: ''
      }

      form = Panel::CreateCollectionsContainerForm.new(collections_container_form_params)

      expect(form.valid?).to eq false
    end

  end
end

describe Panel::UpdateCollectionsContainerForm do
  it 'valid' do
    collections_container_attributes = {
      name: 'Old Name',
      linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1 }}
    }
    collections_container_form_params = {
      name: 'New Name',
      linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1 },
        2 => { collection_id: 2, collections_container_id: 1 }}
    }

    form = Panel::UpdateCollectionsContainerForm.new(
      collections_container_attributes,
      collections_container_form_params
    )

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
  end

  context 'invalid' do
    it 'name' do
      collections_container_attributes = {
        name: 'Old Name',
        linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1 }}
      }
      collections_container_form_params = {
        name: '',
        linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1 },
          2 => { collection_id: 2, collections_container_id: 1 }}
      }

      form = Panel::UpdateCollectionsContainerForm.new(
        collections_container_attributes,
        collections_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'linked_collections_attributes' do
      collections_container_attributes = {
        name: 'Old Name',
        linked_collections_attributes: {1 => { collection_id: 1, collections_container_id: 1 }}
      }
      collections_container_form_params = {
        name: 'Old Name',
        linked_collections_attributes: []
      }

      form = Panel::UpdateCollectionsContainerForm.new(
        collections_container_attributes,
        collections_container_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end

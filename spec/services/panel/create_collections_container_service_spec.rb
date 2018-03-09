describe Panel::CreateCollectionsContainerService do
  it 'call' do
    admin = create :admin, role: Role::Moderator
    collection = create :collection
    collection2 = create :collection

    linked_collections_attributes =  [{ collection_id: collection.id, position: 2} ,{collection_id: collection2.id, position: 1}]
    form = double(
      valid?: true,
      collections_container_attributes: {
        name: 'Name',
        linked_collections_attributes: linked_collections_attributes
      },
      linked_collections: LinkedCollection.create(linked_collections_attributes)
    )

    service = Panel::CreateCollectionsContainerService.new(form, admin)
    expect { service.call }.to change(CollectionsContainer, :count).by(1)
    expect { service.call }.to change(LinkedCollection, :count).by(2)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      collection = create :collection
      form = double(
        valid?: false,
        collections_container_attributes: {
          name: '',
          linked_collections_attributes: [collection.id]
        }
      )

      service = Panel::CreateCollectionsContainerService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change(CollectionsContainer, :count).by(0)
      expect { service.call }.to change(LinkedCollection, :count).by(0)
    end
  end
end

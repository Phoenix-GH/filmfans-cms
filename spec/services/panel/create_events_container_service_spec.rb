describe Panel::CreateEventsContainerService do
  it 'call' do
    admin = create :admin, role: Role::Moderator
    event = create :event
    event2 = create :event

    linked_events_attributes =  [{ event_id: event.id, position: 2} ,{event_id: event2.id, position: 1}]
    form = double(
      valid?: true,
      events_container_attributes: {
        name: 'Name',
        linked_events_attributes: linked_events_attributes
      },
      linked_events: LinkedEvent.create(linked_events_attributes)
    )

    service = Panel::CreateEventsContainerService.new(form, admin)
    expect { service.call }.to change(EventsContainer, :count).by(1)
    expect { service.call }.to change(LinkedEvent, :count).by(2)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      event = create :event
      form = double(
        valid?: false,
        events_container_attributes: {
          name: '',
          linked_events_attributes: [event.id]
        }
      )

      service = Panel::CreateEventsContainerService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change(EventsContainer, :count).by(0)
      expect { service.call }.to change(LinkedEvent, :count).by(0)
    end
  end
end

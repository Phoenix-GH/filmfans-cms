describe Panel::UpdateEventsContainerService do
  it 'call' do
    event = create :event
    event2 = create :event
    event3 = create :event
    events_container = create :events_container, name: 'Old name'
    create :linked_event, event_id: event.id, events_container_id: events_container.id
    create :linked_event, event_id: event2.id, events_container_id: events_container.id

    linked_events_attributes =  [{ event_id: event2.id, position: 2} ,{event_id: event3.id, position: 1}]


    form = double(
      valid?: true,
      events_container_attributes: {
        name: 'New name' ,
        linked_events_attributes: linked_events_attributes
      },
      linked_events: LinkedEvent.create(linked_events_attributes)
    )
    Panel::UpdateEventsContainerService.new(events_container, form).call
    expect(events_container.reload.name).to eq 'New name'
    expect(events_container.linked_events.pluck(:event_id)
    ).to eq [event3.id, event2.id]
  end

  context 'form invalid' do
    it 'returns false' do
      event = create :event
      events_container = create :events_container, name: 'Old name', events: [event]
      form = double(
        valid?: false,
        events_container_attributes: { name: '' },
      )

      service = Panel::UpdateEventsContainerService.new(events_container, form)
      expect(service.call).to eq false
      expect(events_container.reload.name).to eq 'Old name'
    end
  end
end

describe EventsContainerSerializer do
  it 'return' do
    channel = create(:channel)
    events_container = create(:events_container,
      name: 'beautiful events',
      channel: channel,
    )
    event = build(:event)
    event2 = build(:event)
    le1 = create(:linked_event,
      position: 2,
      event: event,
      events_container: events_container
    )
    le2 = create(:linked_event,
      position: 1,
      event: event2,
      events_container: events_container
    )

    results = EventsContainerSerializer.new(events_container).results

    expect(results).to eq(
      {
        type: 'events_container',
        id: events_container.id,
        channel_id: channel.id,
        name: 'beautiful events',
        events: [
          EventSerializer.new(event2, with_content: false).results.merge(event_position: le2.position),
          EventSerializer.new(event, with_content: false).results.merge(event_position: le1.position)
        ],
      }
    )
  end

  it 'missing values' do
    events_container = build(:events_container, name: nil)
    results = EventsContainerSerializer.new(events_container).results
    expect(results).to eq(
      {
        type: 'events_container',
        id: events_container.id,
        channel_id: 0,
        name: '',
        events: []
      }
    )
  end
end

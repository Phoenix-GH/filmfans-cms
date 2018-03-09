describe Panel::UpdateEventsContainerForm do
  it 'valid' do
    events_container_attributes = {
      name: 'Old Name',
      linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 }}
    }
    events_container_form_params = {
      name: 'New Name',
      linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 },
        2 => { event_id: 2, events_container_id: 1 }}
    }

    form = Panel::UpdateEventsContainerForm.new(
      events_container_attributes,
      events_container_form_params
    )

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
  end

  context 'invalid' do
    it 'name' do
      events_container_attributes = {
        name: 'Old Name',
        linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 }}
      }
      events_container_form_params = {
        name: '',
        linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 },
          2 => { event_id: 2, events_container_id: 1 }}
      }

      form = Panel::UpdateEventsContainerForm.new(
        events_container_attributes,
        events_container_form_params
      )

      expect(form.valid?).to eq false
    end

    it 'linked_events_attributes' do
      events_container_attributes = {
        name: 'Old Name',
        linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 }}
      }
      events_container_form_params = {
        name: 'Old Name',
        linked_events_attributes: []
      }

      form = Panel::UpdateEventsContainerForm.new(
        events_container_attributes,
        events_container_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end

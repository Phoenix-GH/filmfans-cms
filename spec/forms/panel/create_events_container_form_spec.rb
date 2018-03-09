describe Panel::CreateEventsContainerForm do
  it 'valid' do
    events_container_form_params = {
      name: 'Old Name',
      linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 }}
    }

    form = Panel::CreateEventsContainerForm.new(events_container_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name' do
      events_container_form_params = {
        name: '',
        linked_events_attributes: {1 => { event_id: 1, events_container_id: 1 }}
      }

      form = Panel::CreateEventsContainerForm.new(events_container_form_params)

      expect(form.valid?).to eq false
    end

    it 'linked_events' do
      events_container_form_params = {
        name: 'Old Name'
      }

      form = Panel::CreateEventsContainerForm.new(events_container_form_params)

      expect(form.valid?).to eq false
    end

  end
end

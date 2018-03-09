describe Panel::UpdateChannelForm do
  it 'valid' do
    channel_attributes = attributes_for :channel
    channel_form_params = attributes_for :channel, name: 'New Name'

    form = Panel::UpdateChannelForm.new(channel_attributes, channel_form_params)

    expect(form.valid?).to eq true
    expect(form.name).to eq 'New Name'
  end

  context 'invalid' do
    it 'name: presence' do
      channel_attributes = attributes_for :channel
      channel_form_params = attributes_for :channel, name: ''

      form = Panel::UpdateChannelForm.new(channel_attributes, channel_form_params)

      expect(form.valid?).to eq false
    end
  end
end

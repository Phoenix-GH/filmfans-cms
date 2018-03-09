describe Panel::CreateChannelForm do
  it 'valid' do
    channel_form_params = attributes_for :channel

    form = Panel::CreateChannelForm.new(channel_form_params)

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'name: presence' do
      channel_form_params = attributes_for :channel, name: ''
      form = Panel::CreateChannelForm.new(channel_form_params)

      expect(form.valid?).to eq false
    end

    it 'picture: presence' do
      channel_form_params = attributes_for :channel, picture: nil
      form = Panel::CreateChannelForm.new(channel_form_params)

      expect(form.valid?).to eq false
    end
  end

end

describe Panel::UpdateFeedSettingsService do
  it 'activate' do
    channel = create(:channel, feed_active: false)
    params = { feed_active: true }
    service = Panel::UpdateFeedSettingsService.new(channel, params)
    service.call
    expect(channel.reload.feed_active?).to eq(true)
  end

  it 'activate and sets dialogfeed url' do
    channel = create(:channel, feed_active: false)
    params = { feed_active: true, dialogfeed_url: 'url_to_dialogfeed' }
    service = Panel::UpdateFeedSettingsService.new(channel, params)
    service.call
    expect(channel.reload.feed_active?).to eq(true)
    expect(channel.reload.dialogfeed_url).to eq('url_to_dialogfeed')
  end

  it 'inactivate' do
    channel = create(:channel, feed_active: true)
    params = { feed_active: false }
    service = Panel::UpdateFeedSettingsService.new(channel, params)
    service.call
    expect(channel.reload.feed_active?).to eq(false)
  end
end

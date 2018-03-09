describe Panel::DestroyMediaContentService do
  it 'call' do
    media_container = create :media_container
    media_content = create :media_content, membership: media_container

    service = Panel::DestroyMediaContentService.new(media_content)
    expect { service.call }.to change { MediaContent.count }.by(0)
  end
end

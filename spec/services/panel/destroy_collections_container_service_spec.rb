describe Panel::DestroyCollectionsContainerService do
  it 'remove collections_container' do
    collections_container = create(:collections_container)
    service = Panel::DestroyCollectionsContainerService.new(collections_container)
    expect{
      service.call
    }.to change(CollectionsContainer, :count).by(-1)
  end

  it 'remove home_content relations' do
    collections_container = create(:collections_container)
    create(:home_content, content: collections_container)
    service = Panel::DestroyCollectionsContainerService.new(collections_container)
    expect{
      service.call
    }.to change(HomeContent, :count).by(-1)
  end

  it 'remove trending_content relations' do
    collections_container = create(:collections_container)
    create(:trending_content, content: collections_container)
    service = Panel::DestroyCollectionsContainerService.new(collections_container)
    expect{
      service.call
    }.to change(TrendingContent, :count).by(-1)
  end
end

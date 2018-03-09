describe Panel::SortHomeContentsService do
  it 'reorder positions' do
    home = create(:home)
    content = create(
      :home_content,
      content_id: 1,
      content_type: 'ProductsContainer',
      home: home,
      position: 1
    )
    content2 = create(
      :home_content,
      content_id: 1,
      content_type: 'CollectionsContainer',
      home: home,
      position: 2
    )

    params = {
      "0": {
      id: content2.id,
      position: 1
    },
      "1": {
      id: content.id,
      position: 2
    }
    }

    service = Panel::SortHomeContentsService.new(home, params)
    service.call
    contents_order = home.reload.home_contents.order(:position).pluck(:id)
    expect(contents_order).to eq([content2.id, content.id])
  end
end

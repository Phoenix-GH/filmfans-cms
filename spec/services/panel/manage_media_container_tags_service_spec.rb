describe Panel::ManageMediaContainerTagsService do
  it 'adds new tags' do
    media_container = build_stubbed :media_container
    product = create :product, name: 'Chanel Dress'
    data = {
      '0' => {
        x: '0.47848360655737704',
        y: '0.1151603498542274',
        text: 'Chanel Dress'
      },
      '1' => {
        x: '0.4600409836065574',
        y: '0.5422740524781341',
        text: 'nie'
      }
    }

    service = Panel::ManageMediaContainerTagsService.new(media_container, data)
    expect { service.call }.to change { Tag.count }.by(1)
  end

  it 'updates tags list' do
    media_container = create :media_container
    product = create :product, name: 'Chanel Dress'
    product2 = create :product, name: 'Gucci Dress'
    tag = create :tag,
      coordinate_x: '0.111',
      coordinate_y: '0.111',
      media_container_id: media_container.id,
      product_id: product.id
    data = {
      '0' => {
        x: '0.2222222222222222',
        y: '0.2222222222222222',
        text: 'Gucci Dress'
      }
    }
    expect(media_container.tags.reload.pluck(:product_id)).to eq([product.id])

    service = Panel::ManageMediaContainerTagsService.new(media_container, data)
    expect { service.call }.to change { Tag.count }.by(0)
    expect(media_container.tags.reload.pluck(:product_id)).to eq([product2.id])
  end
end

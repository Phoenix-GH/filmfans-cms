describe Panel::ToggleProductContainerPlacementService do
  it 'activate' do
    product = create(:product, containers_placement: false)

    service = Panel::ToggleProductContainerPlacementService.new(product)
    service.call
    expect(product.reload.containers_placement).to eq(true)
  end

  it 'inactivate' do
    product = create(:product, containers_placement: true)

    service = Panel::ToggleProductContainerPlacementService.new(product)
    service.call
    expect(product.reload.containers_placement).to eq(false)
  end
end

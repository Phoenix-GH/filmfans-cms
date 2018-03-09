describe Panel::SortProductsContainerService do
  it 'reorder positions' do
    container = create(:products_container)
    create(:linked_product,
      product_id: 1,
      products_container: container,
      position: 1
    )
    create(:linked_product,
      product_id: 2,
      products_container: container,
      position: 2
    )

    params = {
      "0": {
        id: 2,
        position: 1
      },
      "1": {
        id: 1,
        position: 2
      }
    }

    service = Panel::SortProductsContainerService.new(container, params)
    service.call
    products_oreder = container.reload.linked_products.order(:position).pluck(:product_id)
    expect(products_oreder).to eq([2, 1])
  end
end

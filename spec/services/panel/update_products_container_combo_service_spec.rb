describe Panel::UpdateProductsContainerComboService do
  it 'call' do
    product = create :product
    product2 = create :product
    product3 = create :product
    products_container = create :products_container, name: 'Old name'
    create :linked_product, product_id: product.id, products_container_id: products_container.id
    create :linked_product, product_id: product2.id, products_container_id: products_container.id

    form = double(
      valid?: true,
      products_container_attributes: {
        name: 'New name' ,
        product_ids: [product2.id ,product3.id]
      }
    )
    Panel::UpdateProductsContainerComboService.new(products_container, form).call
    expect(products_container.reload.name).to eq 'New name'
    expect(products_container.linked_products.pluck(:product_id)
    ).to eq [product2.id ,product3.id]
  end

  context 'form invalid' do
    it 'returns false' do
      product = create :product
      products_container = create :products_container, name: 'Old name', products: [product]
      form = double(
        valid?: false,
        products_container_attributes: { name: '' },
      )

      service = Panel::UpdateProductsContainerComboService.new(products_container, form)
      expect(service.call).to eq false
      expect(products_container.reload.name).to eq 'Old name'
    end
  end
end

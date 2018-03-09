describe Panel::CreateProductsContainerComboService do
  it 'call' do
    product = create :product
    product2 = create :product
    media_content = create(:media_content)
    owner = create(:media_owner)
    form = double(
      valid?: true,
      products_container_attributes: {
        name: 'Name',
        description: 'description',
        product_ids: [product.id ,product2.id],
        media_owner_id: owner.id,
        media_content: media_content
      }
    )

    service = Panel::CreateProductsContainerComboService.new(form)
    expect { service.call }.to change(ProductsContainer, :count).by(1)
    expect { service.call }.to change(LinkedProduct, :count).by(2)
    service.call
    product_container = ProductsContainer.last
    expect(product_container.media_owner).to eq(owner)
    expect(product_container.media_content).to eq(media_content)
  end

  context 'form invalid' do
    it 'returns false' do
      product = create :product
      form = double(
        valid?: false,
        products_container_attributes: {
          name: '',
          description: 'old description',
          products_ids: [product.id]
        }
      )

      service = Panel::CreateProductsContainerComboService.new(form)
      expect(service.call).to eq(false)
      expect { service.call }.to change(ProductsContainer, :count).by(0)
      expect { service.call }.to change(LinkedProduct, :count).by(0)
    end
  end
end

describe Panel::CreateProductsContainerService do
  it 'call' do
    admin = create :admin, role: Role::Moderator
    product = create :product
    product2 = create :product
    media_content = create(:media_content)
    owner = create(:media_owner)

    linked_products_attributes =  [{ product_id: product.id, position: 2} ,{product_id: product2.id, position: 1}]

    form = double(
      valid?: true,
      products_container_attributes: {
        name: 'Name',
        description: 'description',
        linked_products_attributes: linked_products_attributes,
        media_owner_id: owner.id,
        media_content: media_content
      },
      linked_products: LinkedProduct.create(linked_products_attributes)
    )

    service = Panel::CreateProductsContainerService.new(form, admin)
    expect { service.call }.to change(ProductsContainer, :count).by(1)
    expect { service.call }.to change(LinkedProduct, :count).by(2)
    service.call
    product_container = ProductsContainer.last
    expect(product_container.media_owner).to eq(owner)
    expect(product_container.media_content).to eq(media_content)
  end

  context 'form invalid' do
    it 'returns false' do
      admin = create :admin, role: Role::Moderator
      product = create :product
      form = double(
        valid?: false,
        products_container_attributes: {
          name: '',
          description: 'old description',
          products_ids: [product.id]
        }
      )

      service = Panel::CreateProductsContainerService.new(form, admin)
      expect(service.call).to eq(false)
      expect { service.call }.to change(ProductsContainer, :count).by(0)
      expect { service.call }.to change(LinkedProduct, :count).by(0)
    end
  end
end

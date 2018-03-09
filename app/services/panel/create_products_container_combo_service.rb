class Panel::CreateProductsContainerComboService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_products_container
  end

  private

  def create_products_container
    ProductsContainer.create(@form.products_container_attributes)
  end
end

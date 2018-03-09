class Panel::UpdateProductsContainerComboService
  def initialize(products_container, form)
    @products_container = products_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_products_container
  end

  private

  def update_products_container
    @products_container.update_attributes(@form.products_container_attributes)
  end

end

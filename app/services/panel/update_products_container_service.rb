class Panel::UpdateProductsContainerService
  def initialize(products_container, form)
    @products_container = products_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_products_container
    add_linked_products
  end

  def products_container
    @products_container
  end

  private

  def update_products_container
    category = @form.category_id&.blank? ? nil : Category.find(@form.category_id)
    translation = @products_container.translation.deep_merge(@form.translation)
    @products_container.update_attributes(@form.products_container_attributes.merge(
        {
            category: category,
            name: category.nil? ? @form.name : category.full_name,
            translation: translation
        }))
  end

  def add_linked_products
    Panel::CreateLinkedProductService.new(@products_container, @form.linked_products).call
  end

end

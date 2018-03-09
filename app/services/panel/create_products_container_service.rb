class Panel::CreateProductsContainerService
  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_products_container
    add_linked_products
    add_admin_id
  end

  def products_container
    @products_container
  end

  private

  def create_products_container
    category = @form.category_id&.blank? ? nil : Category.find(@form.category_id)

    @products_container = ProductsContainer.create(@form.products_container_attributes.merge(
        {
            category: category,
            name: category.nil? ? @form.name : category.full_name,
            translation: @form.translation
        }))
  end

  def add_linked_products
    Panel::CreateLinkedProductService.new(@products_container, @form.linked_products).call
  end

  def add_admin_id
    if @user.role == 'moderator'
      @products_container.update_attributes(admin_id: @user.id)
    end

    true
  end
end

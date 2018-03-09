class Panel::Wizards::CreateProductService
  def initialize(form)
    @form = form
  end

  attr_reader(
    :product
  )

  def call
    return false unless @form.valid?
    ActiveRecord::Base.transaction do
      create_product
      add_product_categories
    end
  end

  private
  def create_product
    @product = Product.create(@form.product_attributes)
    # @product.product_files = @form.product_file_attributes
    # @product.save
  end

  def add_product_categories
    Panel::Wizards::CreateProductCategoryService.new(@product, @form.category_ids).call
  end
end

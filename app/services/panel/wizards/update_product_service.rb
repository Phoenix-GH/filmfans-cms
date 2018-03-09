class Panel::Wizards::UpdateProductService
  def initialize(product, form)
    @product = product
    @form = form
  end

  def call
    return false unless @form.valid?
    ActiveRecord::Base.transaction do
      update_product
      update_product_categories
    end
    true
  end

  private
  def update_product
    @product.update_attributes(@form.product_attributes)
    # TODO updating of product_files
    # FIXME!
    # @product.product_files.first.update_attributes(@form.product_file_attributes)
  end

  def update_product_categories
    Panel::Wizards::CreateProductCategoryService.new(@product, @form.category_ids).call
  end
end

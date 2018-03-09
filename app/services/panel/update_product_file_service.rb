class Panel::UpdateProductFileService
  def initialize(product_file, form)
    @product_file = product_file
    @form = form
  end

  def call
    return false unless @form.valid?

    update_product_file
  end

  private

  def update_product_file
    @product_file.update_attributes(@form.attributes)
  end
end

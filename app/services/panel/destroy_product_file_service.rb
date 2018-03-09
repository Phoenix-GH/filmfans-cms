class Panel::DestroyProductFileService
  def initialize(product_file)
    @product_file = product_file
  end

  def call
    return false if first_product_file

    destroy_product_file
  end

  private

  def destroy_product_file
    @product_file.destroy
  end

  def first_product_file
    @product_file == @product_file.product.product_files.first
  end
end

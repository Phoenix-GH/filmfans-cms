class Panel::CreateProductFileService
  attr_reader :product_file

  def initialize(form:, product: nil)
    @form = form
    @product = product
  end

  def call
    return false unless @form.valid?

    create_product_file
    create_product_file_cover_image
  end

  private

  def create_product_file
    if @product
      @product_file = @product.product_files.create(@form.attributes)
    else
      @product_file = ProductFile.create(@form.attributes)
    end
  end

  def create_product_file_cover_image
    Panel::CreateFileModelCoverImageService.new(@product_file).call
  end
end

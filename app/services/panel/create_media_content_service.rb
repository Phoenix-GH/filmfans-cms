class Panel::CreateMediaContentService
  attr_reader :media_content

  def initialize(form:, product: nil)
    @form = form
    @product = product
  end

  def call
    return false unless @form.valid?

    create_media_content
    create_media_content_cover_image
  end

  private

  def create_media_content
    if @product
      @media_content = @product.product_files.create(@form.attributes)
    else
      @media_content = MediaContent.create(@form.attributes)
    end
  end

  def create_media_content_cover_image
    Panel::CreateFileModelCoverImageService.new(@media_content).call
  end
end

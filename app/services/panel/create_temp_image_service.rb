class Panel::CreateTempImageService
  attr_reader :temp_image

  def initialize(form:, product: nil)
    @form = form
    @product = product
  end

  def call
    return false unless @form.valid?
    create_temp_image
  end

  private

  def create_temp_image
    @temp_image = TempImage.create(@form.attributes)
  end
end

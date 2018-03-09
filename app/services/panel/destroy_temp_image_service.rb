class Panel::DestroyTempImageService
  def initialize(temp_image)
    @temp_image = temp_image
  end

  def call
    destroy_product_file
  end

  private

  def destroy_product_file
    @temp_image.destroy
  end


end

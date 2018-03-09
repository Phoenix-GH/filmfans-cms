class Panel::UpdateProductFileForm
  include ActiveModel::Model

  attr_accessor(
    :cover_image, :file
  )

  def initialize(product_file_attrs, form_attributes = {})
    super product_file_attrs.merge(form_attributes)
  end

  validates :cover_image, :file, presence: true
  validates :cover_image, image_format: true


  def attributes
    {
      cover_image: cover_image,
      file: file
    }
  end
end

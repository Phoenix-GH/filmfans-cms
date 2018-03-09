class Panel::CreateMediaContentForm
  include ActiveModel::Model

  attr_accessor(
    :cover_image, :file
  )

  validates :file, presence: true
  validates :file, allowed_content_type: true

  def attributes
    {
      cover_image: cover_image,
      file: file
    }
  end
end

class Panel::CreateCollectionForm
  include ActiveModel::Model

  attr_accessor(
    :name, :background_image, :cover_image
  )

  validates :background_image, presence: true

  def collection_attributes
    {
      name: name
    }
  end

  def background_image_attributes
    background_image || {}
  end

  def cover_image_attributes
    background_image_attributes
  end
end

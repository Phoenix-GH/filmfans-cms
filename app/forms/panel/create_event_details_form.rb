class Panel::CreateEventDetailsForm
  include ActiveModel::Model

  attr_accessor(
    :name, :background_image
  )

  validates :name, presence: true

  def attributes
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

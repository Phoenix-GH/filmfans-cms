class Panel::UpdateEventDetailsForm
  include ActiveModel::Model

  attr_accessor(
      :name, :background_image
  )

  def initialize(media_owner_attrs, form_attributes = {})
    super media_owner_attrs.merge(form_attributes)
  end

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

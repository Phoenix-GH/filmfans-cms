class Panel::UpdateMagazineForm
  include ActiveModel::Model

  attr_accessor(
    :title, :description, :channel_id, :cover_image, :background_image
  )

  def initialize(magazine_attrs, form_attributes = {})
    super magazine_attrs.merge(form_attributes)
  end

  # :cover_image is not required here because if users don't change it, it's not in the form
  validates :title, presence: true

  def attributes
    {
      title: title,
      description: description,
      channel_id: channel_id,
    }
  end

  def cover_image_attributes
    cover_image || {}
  end

  def background_image_attributes
    cover_image_attributes
  end
end


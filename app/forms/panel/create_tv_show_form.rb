class Panel::CreateTvShowForm
  include ActiveModel::Model

  attr_accessor(
    :title, :description, :channel_id, :cover_image, :background_image, :form_type
  )

  validates :background_image, presence: true

  def attributes
    {
      title: title,
      description: description,
      channel_id: channel_id,
    }
  end

  def background_image_attributes
    background_image || {}
  end

  def cover_image_attributes
    background_image_attributes
  end
end

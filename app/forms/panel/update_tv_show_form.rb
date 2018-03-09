class Panel::UpdateTvShowForm
  include ActiveModel::Model

  attr_accessor(
    :title, :description, :channel_id, :cover_image, :background_image
  )

  def initialize(tv_show_attrs, form_attributes = {})
    super tv_show_attrs.merge(form_attributes)
  end

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



class Panel::UpdateMediaOwnerForm
  include ActiveModel::Model

  attr_accessor(
    :name, :picture, :url, :background_image, :dialogfeed_url
  )

  def initialize(media_owner_attrs, form_attributes = {})
    super media_owner_attrs.merge(form_attributes)
  end

  validates :name, presence: true

  def attributes
    {
      name: name,
      url: url,
      dialogfeed_url: dialogfeed_url
    }
  end

  def picture_attributes
    picture || {}
  end

  def background_image_attributes
    background_image || {}
  end
end

class Panel::CreateMediaOwnerForm
  include ActiveModel::Model

  attr_accessor(
    :name, :picture, :url, :background_image, :dialogfeed_url
  )

  validates :name, :picture, presence: true

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

class Panel::BaseThreedArForm
  include ActiveModel::Model

  attr_accessor(
      :name, :image, :message
  )

  validates :name, :image, presence: true

  def attributes
    {
        name: name,
        image: image,
        message: message
    }
  end

  def image_attributes
    image || {}
  end
end
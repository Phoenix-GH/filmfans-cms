class Panel::CreateTempImageForm
  include ActiveModel::Model

  attr_accessor(
    :image
  )

  validates :image, presence: true


  def attributes
    {
      image: image
    }
  end
end

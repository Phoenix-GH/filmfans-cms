class Panel::CreateHomeForm
  include ActiveModel::Model

  attr_accessor(
    :name, :home_type
  )

  validates :name, :home_type, presence: true

  def home_attributes
    {
      name: name,
      home_type: home_type
    }
  end
end

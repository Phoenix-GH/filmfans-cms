class Panel::UpdateHomeForm
  include ActiveModel::Model

  attr_accessor(
    :id, :name, :home_type
  )

  validates :name, :home_type, presence: true

  def initialize(home_attrs, form_attributes = {})
    super home_attrs.merge(form_attributes)
  end

  def home_attributes
    {
      name: name,
      home_type: home_type
    }
  end
end

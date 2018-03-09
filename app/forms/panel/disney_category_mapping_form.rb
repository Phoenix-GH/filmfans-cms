class Panel::DisneyCategoryMappingForm
  include ActiveModel::Model

  attr_accessor(
      :new_name, :disney_cat
  )

  validates :new_name, :disney_cat, presence: true

  def attributes
    {
        new_name: new_name,
        disney_cat: disney_cat
    }
  end
end

class Panel::UpdateCategoryForm
  include ActiveModel::Model

  attr_accessor(
      :name,
      :icon,
      :image,
      :parent_id
  )

  def initialize(category_attrs, form_attributes = {})
    super category_attrs.merge(form_attributes)
  end

  validates :name, :icon, :image, presence: true
  validates :icon, :image, image_format: true

  def category_attributes
    {
        name: name,
        icon: icon,
        image: image,
        parent_id: parent_id
    }
  end
end

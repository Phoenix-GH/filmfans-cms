class Panel::Wizards::UpdateProductForm
  include ActiveModel::Model

  attr_accessor(
    :id,
    :name,
    :brand,
    :category_ids,
    :shipping_info,
    :vendor_url,
    :containers_placement
  )

  def initialize(product_attributes, form_attributes = {})
    super product_attributes.merge(form_attributes)
  end

  validates :brand, :name, :category_ids, presence: true
  validates :name, product_uniqueness: true

  def product_attributes
    {
      id: id,
      brand: brand,
      name: name,
      shipping_info: shipping_info,
      vendor_url: vendor_url,
      containers_placement: containers_placement,
      category_ids: category_ids
    }
  end
end

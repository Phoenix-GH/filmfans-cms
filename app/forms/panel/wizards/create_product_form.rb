class Panel::Wizards::CreateProductForm
  include ActiveModel::Model

  attr_accessor(
    :name,
    :brand,
    :shipping_info,
    :vendor_url,
    :containers_placement,
    :category_ids
  )

  validates :brand, :name, :category_ids, presence: true
  validates :name, product_uniqueness: true

  def product_attributes
    {
      name: name,
      brand: brand,
      shipping_info: shipping_info,
      vendor_url: vendor_url,
      containers_placement: containers_placement
    }
  end
end

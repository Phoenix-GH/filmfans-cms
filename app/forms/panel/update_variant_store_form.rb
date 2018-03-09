class Panel::UpdateVariantStoreForm
  include ActiveModel::Model

  attr_accessor(
    :currency, :price, :url, :sku
  )

  def initialize(variant_store_attrs, form_attributes = {})
    super variant_store_attrs.merge(form_attributes)
  end

  validates :currency, :price, :url, presence: true
  validates :price, numericality: true

  def attributes
    {
      currency: currency,
      price: price,
      url: url,
      sku: sku
    }
  end
end

class Panel::CreateVariantStoreForm
  include ActiveModel::Model

  attr_accessor(
    :currency, :price, :url, :sku
  )

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

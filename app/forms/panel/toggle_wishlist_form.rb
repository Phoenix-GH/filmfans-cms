class Panel::ToggleWishlistForm
  include ActiveModel::Model

  attr_accessor(
    :product_id,
    :user_id
  )

  validates :user_id, presence: true
  validate :product_existence

  def wishlist_attributes
    {
      product_id: product_id,
      user_id: user_id
    }
  end

  private

  def product_existence
    if Product.find_by(id: product_id).blank?
      errors[:base] << _("Product not found.")
    end
  end
end

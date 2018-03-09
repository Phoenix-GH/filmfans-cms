class Panel::ToggleWishlistService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    toggle_wishlist
  end

  private

  def toggle_wishlist
    if wishlist = Wishlist.find_by(@form.wishlist_attributes)
      wishlist.destroy
    else
      Wishlist.create(@form.wishlist_attributes)
    end
  end

end

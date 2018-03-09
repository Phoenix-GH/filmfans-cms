describe Panel::ToggleWishlistService do
  context 'toggle' do
    it 'create' do
      user = create(:user)
      product = create(:product)
      form = double(
        valid?: true,
        wishlist_attributes: {
          user_id: user.id,
          product_id: product.id
        }
      )
      service = Panel::ToggleWishlistService.new(form)
      expect { service.call }.to change { Wishlist.count }.by(1)
    end

    it 'destroy' do
      user = create(:user)
      product = create(:product)
      create(:wishlist, user: user, product: product)
      form = double(
        valid?: true,
        wishlist_attributes: {
          user_id: user.id,
          product_id: product.id
        }
      )

      service = Panel::ToggleWishlistService.new(form)
      expect { service.call }.to change { Wishlist.count }.by(-1)
    end
  end
end

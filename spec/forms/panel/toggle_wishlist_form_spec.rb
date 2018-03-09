describe Panel::ToggleWishlistForm do
  it 'valid' do
    user = create(:user)
    product = create(:product)
    form = Panel::ToggleWishlistForm.new(
      {
        user_id: user.id,
        product_id: product.id
      }
    )

    expect(form.valid?).to eq true
  end

  context 'invalid' do
    it 'product_id' do
      user = create(:user)

      form = Panel::ToggleWishlistForm.new(
        {
          user_id: user.id,
          product_id: nil
        }
      )

      expect(form.valid?).to eq false
    end

    it 'product' do
      user = create(:user)

      form = Panel::ToggleWishlistForm.new(
        {
          user_id: user.id,
          product_id: 5
        }
      )

      expect(form.valid?).to eq false
    end
  end

end

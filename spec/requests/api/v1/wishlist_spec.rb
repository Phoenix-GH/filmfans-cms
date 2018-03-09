describe 'Wishlists requests' do
  context '/wishlists' do
    it 'wishlist index' do
      user = create(:user)
      product = create(:product, name: 'Product')
      product2 = create(:product, name: 'Product2')
      product3 = create(:product, name: 'Product3')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:wishlist, user: user, product_id: product.id)
      create(:wishlist, user: user, product_id: product2.id)
      create(:snapped_product, user: user, product_id: product3.id)

      get "/api/v1/wishlists/", {}, new_auth_header
      body = ActiveSupport::JSON.decode(response.body)

      expect(body[0]['name']).to eq('Product')
      expect(body[1]['name']).to eq('Product2')
      expect(body[2]).to be_nil
    end

    it 'wishlist index error' do
      user = create(:user)
      product = create(:product, name: 'Product')
      product2 = create(:product, name: 'Product2')

      create(:wishlist, user: user, product_id: product.id)
      create(:wishlist, user: user, product_id: product2.id)

      get "/api/v1/wishlists/"
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']).to_not be_empty
    end
  end

  context '/wishlists/toggle' do
    it 'wish product' do
      user = create(:user)
      product = create(:product, name: 'Product')
      product2 = create(:product, name: 'Product2')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:wishlist, user: user, product_id: product.id)

      post "/api/v1/wishlists/toggle",
        { product_id: product2.id }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)

      expect(body['user_wishlist_count']).to eq(2)
      expect(user.saved_products.first).to eq(product)
    end

    it 'wish product error' do
      user = create(:user)
      product = create(:product, name: 'Product')
      product2 = create(:product, name: 'Product2')

      create(:wishlist, user: user, product_id: product.id)

      post "/api/v1/wishlists/toggle",
        { product_id: product2.id }
      body = ActiveSupport::JSON.decode(response.body)

      expect(body['errors']).to_not be_empty
    end

    it 'unwish product' do
      user = create(:user)
      product = create(:product, name: 'product')
      product2 = create(:product, name: 'product2')
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:wishlist, user: user, product_id: product.id)
      create(:wishlist, user: user, product_id: product2.id)

      post "/api/v1/wishlists/toggle",
        { product_id: product.id }, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body['is_on_wishlist']).to eq(false)
      expect(body['user_wishlist_count']).to eq(1)
    end

    it 'invlid product id' do
      user = create(:user)
      new_auth_header = user.create_new_auth_token(user.tokens.keys[0])

      create(:wishlist, user: user)

      post "/api/v1/wishlists/toggle",
        {products_id: 5}, new_auth_header

      body = ActiveSupport::JSON.decode(response.body)
      expect(body).to eq(['Product not found.'])
    end
  end

end

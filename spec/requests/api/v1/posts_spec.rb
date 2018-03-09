describe 'Posts requests' do
  it '/api/v1/posts/:id' do
    media_owner = create(:media_owner)
    source = create(:facebook_source, source_owner: media_owner)
    post = create(:image_post, source: source)
    product = create(:product)
    product2 = create(:product)
    product3 = create(:product)
    create(:post_product, post: post, product: product)
    create(:post_product, post: post, product: product2, position: 2)
    create(:post_product, post: post, product: product3, position: 3)
    get "/api/v1/posts/#{post.id}"
    body = ActiveSupport::JSON.decode(response.body)
    expect(body['post']['id']).to eq(post.id)
    expect(body['products'].length).to eq(3)
  end
end

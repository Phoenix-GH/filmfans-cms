class Panel::UpdatePostProductsService
  def initialize(post, form)
    @post = post
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_post_products
      create_new_post_products
    end
  end

  private

  def remove_old_post_products
    @post.post_products.delete_all
  end

  def create_new_post_products
    @form.post_products.each do |post_product|
      position = post_product[:position]
      product = Product.find_by(id: post_product[:product_id])
      if product
        @post.post_products.create(product: product, position: position)
      end
    end
  end
end

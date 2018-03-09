class Panel::UpdateManualPostProductsService
  def initialize(manual_post, form)
    @manual_post = manual_post
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_products
      create_new_products
    end
  end

  private

  def remove_old_products
    @manual_post.manual_post_products.delete_all
  end

  def create_new_products
    @form.manual_post_products.each do |product|
      position = product[:position]
      product = Product.find_by(id: product[:product_id])
      if product
        @manual_post.manual_post_products.create(product: product, position: position)
      end
    end
  end
end
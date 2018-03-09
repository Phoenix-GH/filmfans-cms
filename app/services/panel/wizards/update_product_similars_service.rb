class Panel::Wizards::UpdateProductSimilarsService
  def initialize(product, form)
    @product = product
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_similar_products
      create_new_similar_products
    end
  end

  private

  def remove_old_similar_products
    @product.product_similarity.delete_all
  end

  def create_new_similar_products
    @form.similar_products.each do |similar_product|
      product = Product.find_by(id: similar_product[:product_to_id])
      if product
        @product.product_similarity.create(product_to: product)
      end
    end
  end
end

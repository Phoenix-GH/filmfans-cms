class Panel::UpdateThreedModelProductsService
  def initialize(threed_model, form)
    @threed_model = threed_model
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_products
      create_new_products
    end
    true
  end

  private

  def remove_old_products
    @threed_model.threed_model_products.delete_all unless @threed_model.blank?
  end

  def create_new_products
    @form.threed_model_products.each do |product|
      position = product[:position]
      product = Product.find_by(id: product[:product_id])
      if product
        @threed_model.threed_model_products.create(product: product, position: position)
      end
    end
  end
end

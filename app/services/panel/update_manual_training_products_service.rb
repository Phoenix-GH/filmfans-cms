class Panel::UpdateManualTrainingProductsService
  def initialize(manual_training, form)
    @manual_training = manual_training
    @form = form
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_products
      create_new_products
    end
  end

  private

  def remove_old_products
    @manual_training.manual_training_products.delete_all
  end

  def create_new_products
    @form.manual_training_products.each do |product|
      position = product[:position]
      product = Product.find_by(id: product[:product_id])
      if product
        @manual_training.manual_training_products.create(product: product, position: position)
      end
    end
  end
end
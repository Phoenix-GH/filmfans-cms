class Panel::CreateManualTrainingProductService
  def initialize(container, linked_products = [])
    @container = container
    @linked_products = linked_products
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_products
      create_new_products
    end
  end

  private
  def remove_old_products
    @container.manual_training_products.delete_all
  end

  def create_new_products
    @linked_products.each do |linked_product|
      position = linked_product[:position]
      product = Product.find_by(id: linked_product[:product_id])
      if product
        @container.manual_training_products.create(product: product, position: position)
      end
    end
  end
end

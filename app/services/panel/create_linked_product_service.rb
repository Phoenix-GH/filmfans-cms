class Panel::CreateLinkedProductService
  def initialize(container, linked_products = [])
    @container = container
    @linked_products = linked_products
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_linked_products
      create_new_linked_products
    end
  end

  private
  def remove_old_linked_products
    @container.linked_products.delete_all
  end

  def create_new_linked_products
    @linked_products.each do |linked_product|
      position = linked_product[:position]
      product = Product.find_by(id: linked_product[:product_id])
      if product
        @container.linked_products.create(product: product, position: position)
      end
    end
  end
end

class Panel::SortProductsContainerService
  def initialize(products_container, params)
    @products_container = products_container
    @params = params
  end

  def call
    update_all_positions
  end

  private

  def update_all_positions
    @params.each do |key, value|
      @products_container.linked_products
        .find_by(product_id: value[:id])
        .update_attribute(:position ,value[:position])
    end
  end
end

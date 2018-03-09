class Panel::DestroyProductService
  def initialize(product)
    @product = product
  end


  def call
    if @product.manually_added?
      if destroy_product
        remove_product_similarity
      else
        false
      end
    else
      Panel::Wizards::CreateProductCategoryService.new(@product, [Category::QUARANTINE_CATEGORY_ID]).call
    end
  end

  private

  def destroy_product
    @product.destroy
  end

  def remove_product_similarity
    ProductSimilarity.where(product_to: @product).delete_all
  end
end

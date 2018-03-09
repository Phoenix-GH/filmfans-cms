class ProductLearningSerializer
  def initialize(product)
    @product = product
  end

  def results
    return '' unless @product
    generate_product_json
  end

  private
  def generate_product_json
    @product_json = {
      id: @product.id,
      name: @product.name.to_s,
      category_id: category&.id,
      parent_category_id: category&.parent_id,
      category_hierarchy: @product.category_hierarchy,
      default_images: @product.product_files.map(&:thumb_cover_image_url),
      asin: @product.variants.first&.sku&.to_s,
      variants: generate_variants
    }
  end


  def generate_variants
    @product.variants.map do |variant|
      {
        variant_images: variant.variant_files.map(&:thumb_cover_image_url)
      }
    end
  end

  def category
    @category ||= @product.categories.first
  end
end

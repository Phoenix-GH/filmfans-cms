class ProductImageIndexSerializer
  def initialize(product_image_indexes)
    @product_image_indexes = product_image_indexes
  end

  def results
    return {} unless @product_image_indexes

    generate_product_image_index_json
  end

  private
  def generate_product_image_index_json
    @product_image_index_json = {
        id: @product_image_indexes.id,
        system: @product_image_indexes.system.to_s,
        delta_add_file: @product_image_indexes.delta_add_file.to_s,
        delta_add_num: @product_image_indexes.delta_add_num,
        delta_remove_file: @product_image_indexes.delta_remove_file.to_s,
        delta_remove_num: @product_image_indexes.delta_remove_num,
        running: @product_image_indexes.running,
        used: @product_image_indexes.used
    }
  end
end

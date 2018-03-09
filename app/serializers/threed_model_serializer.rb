class ThreedModelSerializer
  def initialize(threed_model)
    @threed_model = threed_model
  end

  def results
    return '' unless @threed_model
    generate_threed_model_json
  end

  private
  def generate_threed_model_json
    {
      id: @threed_model.id.to_i,
      description: @threed_model.description.to_s,
      file_url: @threed_model.file.url.to_s,
      linked_products: linked_products
    }
  end

  def linked_products
    @threed_model.products.map do |p|
      ProductSerializer.new(p, with_similar_products: false).results if p.present?
    end
  end
end

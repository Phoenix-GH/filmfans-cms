class TagSerializer
  def initialize(tag)
    @tag = tag
  end

  def results
    return '' unless @tag
    generate_tag_json
  end

  private
  def generate_tag_json
    {
      id: @tag.id,
      icon: tag_icon,
      coordinate_x: normalized_coordinate(@tag.coordinate_x),
      coordinate_y: normalized_coordinate(@tag.coordinate_y),
      start_time_ms: @tag.coordinate_duration_start,
      end_time_ms: @tag.coordinate_duration_end,
      product: ProductSerializer.new(
        @tag.product,
        with_similar_products: false
      ).results
    }
  end

  def normalized_coordinate(coord)
    coord.present? ? sprintf('%.3f', coord) : ''
  end

  def tag_icon
    icon_url = @tag.product&.primary_category&.icon_url
    icon_url ? icon_url : ''
  end
end

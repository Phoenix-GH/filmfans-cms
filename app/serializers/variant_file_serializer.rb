class VariantFileSerializer
  def initialize(variant_file)
    @variant_file = variant_file
  end

  def results
    return '' unless @variant_file

    generate_variant_file_json
  end

  private
  def generate_variant_file_json
    {
        image: Product::fix_buggy_image_url(@variant_file.large_cover_image_url.to_s),
        small_image: Product::fix_buggy_image_url(@variant_file.small_cover_image_url.to_s),
        medium_image: Product::fix_buggy_image_url(@variant_file.thumb_cover_image_url.to_s),
    }
  end
end

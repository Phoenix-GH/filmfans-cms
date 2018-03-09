class VariantSerializer
  def initialize(variant)
    @variant = variant
  end

  def results
    return '' unless @variant
    generate_variant_json
  end

  private

  def generate_variant_json
    {
        id: @variant.id,
        sku: @variant.sku.to_s,
        description: @variant.get_normalized_description,
        variant_files: variant_files_json,
        variant_stores: stores_json,
        option_values: option_values_json
    }
  end

  def stores_json
    @variant.variant_stores.map do |variant_store|
      VariantStoreSerializer.new(variant_store).results
    end
  end

  def option_values_json
    @variant.option_values.map do |option_value|
      OptionValueSerializer.new(option_value).results
    end
  end

  def variant_files_json
    @variant.variant_files.map do |variant_file|
      VariantFileSerializer.new(variant_file).results
    end
  end
end

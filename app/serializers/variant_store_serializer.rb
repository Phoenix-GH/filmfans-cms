class VariantStoreSerializer
  def initialize(variant_store)
    @variant_store = variant_store
  end

  def results
    return '' unless @variant_store

    generate_variant_store_json
  end

  private

  def generate_variant_store_json
    {
        value: CurrencyService::convert_to_app_currency(@variant_store.sale_price || @variant_store.price, @variant_store.currency),
        currency: CurrencyService::APP_CURRENCY,
        url: @variant_store.url.to_s,
        quantity: @variant_store.quantity.to_s,
        store: store_name
    }
  end

  def store_name
    return '' unless @variant_store.store

    @variant_store.store.name.to_s
  end
end

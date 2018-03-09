class Panel::CreateVariantStoreService
  def initialize(variant, form)
    @variant = variant
    @form = form
  end

  def call
    return false unless @form.valid?

    create_variant_store
  end

  private

  def create_variant_store
    @variant.variant_stores.create(@form.attributes)
  end
end
